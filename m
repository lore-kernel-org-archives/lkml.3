Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaLJRU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:20:56 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:55011 "EHLO
	emvm-gh1-uea09.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaLJRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:20:55 -0500
X-TM-IMSS-Message-ID: <804f0d3b000a0a02@nsa.gov>
Message-ID: <548880B9.8040704@tycho.nsa.gov>
Date: Wed, 10 Dec 2014 12:19:53 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
        jlbec@evilplan.org, "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        Rafal Krypa <r.krypa@samsung.com>,
        Tomasz Swierczek <t.swierczek@samsung.com>,
        "'Karol Lewandowski'" <k.lewandowsk@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Stanislaw Wadas'" <s.wadas@samsung.com>, kopasiak90@gmail.com,
        =?UTF-8?B?J8WBdWthc3ogU3RlbG1hY2gn?= <l.stelmach@samsung.com>
Subject: Re: VFS and LSM issues
References: <022101d01309$09152b00$1b3f8100$%opasiak@samsung.com> <20141210045406.GB11973@kroah.com>
In-Reply-To: <20141210045406.GB11973@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 11:54 PM, Greg KH wrote:
> On Mon, Dec 08, 2014 at 06:04:30PM +0100, Krzysztof Opasiak wrote:
>> Dear All,
>>
>> I'm Krzysztof Opasiak from SRPOL (Samsung). I'm working on USB support
>> in Tizen and mainline. In those works we use two Virtual File Systems
>> - ConfigFS and FunctionFS. Recently I have tried to use them with
>> SMACK and I ran into a few issues. Most of them looks to be a generic
>> problem with many FS and LSM. You can find description of those issues
>> and my research just below in 3 points. I'm not a VFS/LSM specialist so
>> your help is very welcome;)
>>
>> 1) Issues with function FS
>>
>> It's a VFS which allow to provide custom USB function as userspace
>> program. I know that may be quite new for you so let's define this as
>> a VFS which works as follow:
>>
>> $ modprobe g_ffs
>> $ mkdir /tmp/mount_root
>> $ mount none -t functionfs /tmp/mount_root
>> $ ls /tmp/mount_root
>> ep0
>>
>> # now we run our program which writes some data to ep0
>> #  and based on this kernel creates epX
>> # you can find one in tools/usb/ffs-test.c
>>
>> $ ./my_program /tmp/mount_root &
>> $ ls /tmp/mount_root
>> ep0 ep1 ep2
>>
>> Ok so now we would like to use this together with smack. Especially
>> with smackfsdef mount option. First two steps go as above and then:
>>
>> $ mount none -t functionfs -o smackfsdef=my_label /tmp/mount_root
>> $ ls -Z /tmp/mount_root/
>>  _ ep0
>>
>> Ops! Some bug here we requested to use my_label but we got _. When we
>> run our program, rest of epX will get desired label (my_label). I have
>> started to dig in kernel to find what happen and probably I found out
>> where is a problem. Let's look to mount_fs() code which is executed
>> during mount:
>>
>> struct dentry *
>> mount_fs(struct file_system_type *type, int flags, const char *name,
>> void *data)
>> {
>> (...)
>> 	root = type->mount(type, flags, name, data);
>> (...)
>> 	error = security_sb_kern_mount(sb, flags, secdata);
>> (...)
>> }
>>
>> So what is important here is the order of operations. First is
>> executed mount ops provided by selected file system. During this mount
>> procedure functionfs executes new_inode(sb) to allocate inode for ep0
>> which should appear directly after mount. After returning from mount
>> function we execute security_sb_kern_mount() where we *parse the mount
>> options* and sets the value for lsm specific structures for example we
>> store the label passed in smackfsdef.
>>
>> The problem here is order of calls because first we call mount for
>> given fs where we create a file and after this we fill security
>> structures with security mount options. While creating file in mount
>> callback super block is filled only with default values for security
>> so ep0 has _ label. This looks like a generic issue for all VFS which
>> creates indoes before or in their mount procedure.
>>
>> I'm not sure if we can simply move security_sb_kern_mount() above
>> mount for specific fs, do we?
> 
> No, I do not think you can, sorry.
> 
>> 2) Issues with ConfigFS
>>
>> ConfigFS is a generic VFS which allows to create and manage kobjects
>> from userspace. Each module which would like to allow for userland
>> driven configuration register as ConfigFS client called
>> subsystem. Each subsystem has its own directory in ConfigFS root
>> dir. We use libcomposite which appear in ConfigFS as usb_gadget
>> directory. In this dir you can create directories called gadgets. Some
>> example:
>>
>> # libcomposite and configfs compiled-in
>> $ mount none -t configfs /sys/kernel/config
>> $ ls /sys/kernel/config usb_gadget
>> $ mkdir /sys/kernel/config/usb_gadget/g1
>> $ ls /sys/kernel/config/usb_gadget/g1
>> UDC              bDeviceSubClass  bcdUSB     idProduct  strings
>> bDeviceClass     bMaxPacketSize0  configs    idVendor
>> bDeviceProtocol  bcdDevice        functions  os_desc
>>
>>
>> Now let's try to use smack with ConfigFS. First of all we run to
>> similar issue as with FunctionFS so after mounting configfs with
>> smackfsdef option we still get _ label on subsystem directories
>> because they are created in configfs_register_subsystem() which is
>> called in libcomposite module init so really erly. So in my opinion
>> this looks quite similar to issue described in functionfs section.
> 
> Yes, "virtual" filesystems like these haven't probably ever been tested
> with an LSM before, as you are finding out.

On the contrary, SELinux has been used with all of these filesystems for
quite some time...


