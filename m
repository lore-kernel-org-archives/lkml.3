Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaLHREh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:04:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29818 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaLHREf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:04:35 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-03-5485da205346
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, casey@schaufler-ca.com
Cc: jlbec@evilplan.org, "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        gregkh@linuxfoundation.org, "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        Rafal Krypa <r.krypa@samsung.com>,
        Tomasz Swierczek <t.swierczek@samsung.com>,
        "'Karol Lewandowski'" <k.lewandowsk@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Stanislaw Wadas'" <s.wadas@samsung.com>, kopasiak90@gmail.com,
        "=?iso-8859-2?Q?'=A3ukasz_Stelmach'?=" <l.stelmach@samsung.com>
Subject: VFS and LSM issues
Date: Mon, 08 Dec 2014 18:04:30 +0100
Message-id: <022101d01309$09152b00$1b3f8100$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdATCQgFVsWTvgQkQV6oDHdpDfIQuQ==
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xy7oKt1pDDH4uYrKY9bKdxeLetl9s
	Fs2L17NZnDz3jcWi8dNcZotnp/Msbh5awWhxedccNosPPY/YLBYta2W2WHvkLrvFguMtrBYP
	Du9kt3g7aQWzxbIbm5gsft2ewuog4PH0YpDHzll32T32z13D7rHuzysmj74tqxg9ju5fxObx
	eZNcAHuUm01GamJKapFCal5yfkpmXrqtUmiIm66FkkJeYm6qrVKErm9IkJJCWWJOKZBnZIAG
	HJwD3IOV9O0S3DIed99hLujRrDg09QRbA+MExS5GTg4JAROJb4+PsULYYhIX7q1n62Lk4hAS
	WMoo8fJrFyuE08Akce3+NCCHg4NNQF9i3i5RkAYRgRqJqY0nwJqZBT4wS2x9UgJiCwtISxw6
	0sIEYrMIqEo8WnqFBcTmFXCUWN33kR3CFpT4MfkeC8hIZgEdia+TIiDGyEtsXvOWGSQsIaAu
	8eivLsQmPYmJk7cwQZSISNxteM46gVFgFpJBsxAGzUIyaBaSjgWMLKsYRVNLkwuKk9JzDfWK
	E3OLS/PS9ZLzczcxQiL7yw7GxcesDjEKcDAq8fCaK7aGCLEmlhVX5h5ilOBgVhLhXb4TKMSb
	klhZlVqUH19UmpNafIgxGejNicxSosn5wKSTVxJvaGJobmloZGxhYW5kRJqwkjhvxdeWECGB
	9MSS1OzU1ILUIpgtTBycUg2M5s6uvRt6SlcYbm1+wShmxLe4on/R9x9CuzJKjkeVpX9MElu2
	KGFvrlJosaDJzUcC3PevGzJs+ex27kfshGWnfQ68c+BblrnuvJrYbe1zew+vNGmLV0k/oFTM
	PyGj3urK3dM23069/rY+5LLIta0bPLKEPj+L6/H+s/hoBuOq+W8nbP70NdjvmRJLcUaioRZz
	UXEiAGn5qD8wAwAA
X-MTR: 20000000000000000@CPGS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I'm Krzysztof Opasiak from SRPOL (Samsung). I'm working on USB support
in Tizen and mainline. In those works we use two Virtual File Systems
- ConfigFS and FunctionFS. Recently I have tried to use them with
SMACK and I ran into a few issues. Most of them looks to be a generic
problem with many FS and LSM. You can find description of those issues
and my research just below in 3 points. I'm not a VFS/LSM specialist so
your help is very welcome;)

1) Issues with function FS

It's a VFS which allow to provide custom USB function as userspace
program. I know that may be quite new for you so let's define this as
a VFS which works as follow:

$ modprobe g_ffs
$ mkdir /tmp/mount_root
$ mount none -t functionfs /tmp/mount_root
$ ls /tmp/mount_root
ep0

# now we run our program which writes some data to ep0
#  and based on this kernel creates epX
# you can find one in tools/usb/ffs-test.c

$ ./my_program /tmp/mount_root &
$ ls /tmp/mount_root
ep0 ep1 ep2

Ok so now we would like to use this together with smack. Especially
with smackfsdef mount option. First two steps go as above and then:

$ mount none -t functionfs -o smackfsdef=my_label /tmp/mount_root
$ ls -Z /tmp/mount_root/
 _ ep0

Ops! Some bug here we requested to use my_label but we got _. When we
run our program, rest of epX will get desired label (my_label). I have
started to dig in kernel to find what happen and probably I found out
where is a problem. Let's look to mount_fs() code which is executed
during mount:

struct dentry *
mount_fs(struct file_system_type *type, int flags, const char *name,
void *data)
{
(...)
	root = type->mount(type, flags, name, data);
(...)
	error = security_sb_kern_mount(sb, flags, secdata);
(...)
}

So what is important here is the order of operations. First is
executed mount ops provided by selected file system. During this mount
procedure functionfs executes new_inode(sb) to allocate inode for ep0
which should appear directly after mount. After returning from mount
function we execute security_sb_kern_mount() where we *parse the mount
options* and sets the value for lsm specific structures for example we
store the label passed in smackfsdef.

The problem here is order of calls because first we call mount for
given fs where we create a file and after this we fill security
structures with security mount options. While creating file in mount
callback super block is filled only with default values for security
so ep0 has _ label. This looks like a generic issue for all VFS which
creates indoes before or in their mount procedure.

I'm not sure if we can simply move security_sb_kern_mount() above
mount for specific fs, do we?


2) Issues with ConfigFS

ConfigFS is a generic VFS which allows to create and manage kobjects
from userspace. Each module which would like to allow for userland
driven configuration register as ConfigFS client called
subsystem. Each subsystem has its own directory in ConfigFS root
dir. We use libcomposite which appear in ConfigFS as usb_gadget
directory. In this dir you can create directories called gadgets. Some
example:

# libcomposite and configfs compiled-in
$ mount none -t configfs /sys/kernel/config
$ ls /sys/kernel/config usb_gadget
$ mkdir /sys/kernel/config/usb_gadget/g1
$ ls /sys/kernel/config/usb_gadget/g1
UDC              bDeviceSubClass  bcdUSB     idProduct  strings
bDeviceClass     bMaxPacketSize0  configs    idVendor
bDeviceProtocol  bcdDevice        functions  os_desc


Now let's try to use smack with ConfigFS. First of all we run to
similar issue as with FunctionFS so after mounting configfs with
smackfsdef option we still get _ label on subsystem directories
because they are created in configfs_register_subsystem() which is
called in libcomposite module init so really erly. So in my opinion
this looks quite similar to issue described in functionfs section.

Second issue related to Configfs is when we create the directory.
Reproduction:

$ mount none -t configfs -o smackfsdef=my_label /sys/kernel/config
$ ls -Z /sys/kernel/config
_ usb_gadget
$ chmod 777 /sys/kernel/config/usb_gadget
$ chsmack -a my_label /sys/kernel/config/usb_gadget
$ echo my_label > /proc/self/attr/current
$ su my_user
$ mkdir /sys/kernel/config/usb_gadget/g1
$ ls -Z /sys/kernel/config/usb_gadget/
_ g1

As you see our process had my_label label but created by him gadget
has the _ label and the same with all files and subdirs created in
g1. I have no idea why this happened but definetly something is
wrong. Related to this is a policy of labeling subdirectories. Obvious
thing is that g1 directory should have label different that _. But I'm
not shure what label should have its children.

3) Generic question with multi mounts filesystems

Some VFS (ConfigFS for example) can be mounted more than once. What
should be the correct behavior of smackfsdef mount option if we pass
different labels in each mount point?

Looks like all for now. I hope you were able to go through this
email without falling asleep. Thank you in advance.

--
Best regards,

Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com

