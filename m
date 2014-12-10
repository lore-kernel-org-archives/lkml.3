Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaLJRTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:19:11 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:55674 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaLJRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:19:10 -0500
X-TM-IMSS-Message-ID: <a41f4096000afc6e@nsa.gov>
Message-ID: <5488804E.8040404@tycho.nsa.gov>
Date: Wed, 10 Dec 2014 12:18:06 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        casey@schaufler-ca.com
CC: jlbec@evilplan.org, "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        gregkh@linuxfoundation.org, "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        Rafal Krypa <r.krypa@samsung.com>,
        Tomasz Swierczek <t.swierczek@samsung.com>,
        "'Karol Lewandowski'" <k.lewandowsk@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Stanislaw Wadas'" <s.wadas@samsung.com>, kopasiak90@gmail.com,
        =?ISO-8859-2?Q?=27=A3ukasz_Stelmach=27?= <l.stelmach@samsung.com>
Subject: Re: VFS and LSM issues
References: <022101d01309$09152b00$1b3f8100$%opasiak@samsung.com>
In-Reply-To: <022101d01309$09152b00$1b3f8100$%opasiak@samsung.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 12:04 PM, Krzysztof Opasiak wrote:
> Dear All,
> 
> I'm Krzysztof Opasiak from SRPOL (Samsung). I'm working on USB support
> in Tizen and mainline. In those works we use two Virtual File Systems
> - ConfigFS and FunctionFS. Recently I have tried to use them with
> SMACK and I ran into a few issues. Most of them looks to be a generic
> problem with many FS and LSM. You can find description of those issues
> and my research just below in 3 points. I'm not a VFS/LSM specialist so
> your help is very welcome;)
> 
> 1) Issues with function FS
> 
> It's a VFS which allow to provide custom USB function as userspace
> program. I know that may be quite new for you so let's define this as
> a VFS which works as follow:
> 
> $ modprobe g_ffs
> $ mkdir /tmp/mount_root
> $ mount none -t functionfs /tmp/mount_root
> $ ls /tmp/mount_root
> ep0
> 
> # now we run our program which writes some data to ep0
> #  and based on this kernel creates epX
> # you can find one in tools/usb/ffs-test.c
> 
> $ ./my_program /tmp/mount_root &
> $ ls /tmp/mount_root
> ep0 ep1 ep2
> 
> Ok so now we would like to use this together with smack. Especially
> with smackfsdef mount option. First two steps go as above and then:
> 
> $ mount none -t functionfs -o smackfsdef=my_label /tmp/mount_root
> $ ls -Z /tmp/mount_root/
>  _ ep0
> 
> Ops! Some bug here we requested to use my_label but we got _. When we
> run our program, rest of epX will get desired label (my_label). I have
> started to dig in kernel to find what happen and probably I found out
> where is a problem. Let's look to mount_fs() code which is executed
> during mount:
> 
> struct dentry *
> mount_fs(struct file_system_type *type, int flags, const char *name,
> void *data)
> {
> (...)
> 	root = type->mount(type, flags, name, data);
> (...)
> 	error = security_sb_kern_mount(sb, flags, secdata);
> (...)
> }
> 
> So what is important here is the order of operations. First is
> executed mount ops provided by selected file system. During this mount
> procedure functionfs executes new_inode(sb) to allocate inode for ep0
> which should appear directly after mount. After returning from mount
> function we execute security_sb_kern_mount() where we *parse the mount
> options* and sets the value for lsm specific structures for example we
> store the label passed in smackfsdef.
> 
> The problem here is order of calls because first we call mount for
> given fs where we create a file and after this we fill security
> structures with security mount options. While creating file in mount
> callback super block is filled only with default values for security
> so ep0 has _ label. This looks like a generic issue for all VFS which
> creates indoes before or in their mount procedure.
> 
> I'm not sure if we can simply move security_sb_kern_mount() above
> mount for specific fs, do we?

No.  Look at SELinux for an example. It puts the inode security
structures into a list and then initializes them during
security_sb_kern_mount(), both to handle labeling of inodes initialized
before first policy load and to handle inodes created during ->mount().
 In particular, look at the tail of sb_finish_set_opts() in
security/selinux/hooks.c.  As SELinux has been handling this for a long
time, I would call this a bug in Smack, not in the VFS LSM hooks.

