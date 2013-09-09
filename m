Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3IIAMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:12:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39838 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3IIAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:12:41 -0400
Message-ID: <522D1253.1000807@infradead.org>
Date: Sun, 08 Sep 2013 17:12:03 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 01/19] pramfs: documentation
References: <522AE0AD.5020204@gmail.com>
In-Reply-To: <522AE0AD.5020204@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/13 01:15, Marco Stornelli wrote:
> Added pramfs documentation.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  Documentation/filesystems/pramfs.txt |  177 ++++++++++++++++++++++++++++++++++
>  Documentation/filesystems/xip.txt    |    2 +
>  MAINTAINERS                          |    9 ++
>  3 files changed, 188 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/filesystems/pramfs.txt
> 
> diff --git a/Documentation/filesystems/pramfs.txt b/Documentation/filesystems/pramfs.txt
> new file mode 100644
> index 0000000..a61d7a0
> --- /dev/null
> +++ b/Documentation/filesystems/pramfs.txt
> @@ -0,0 +1,177 @@
> +
> +PRAMFS Overview
> +===============
> +
> +Many embedded systems have a block of non-volatile RAM separate from
> +normal system memory, i.e. of which the kernel maintains no memory page
> +descriptors. For such systems it would be beneficial to mount a
> +fast read/write filesystem over this "I/O memory", for storing frequently
> +accessed data that must survive system reboots and power cycles or volatile
> +data avoiding to write on a disk or flash. An example usage might be system
> +logs under /var/log or debug information of a flight-recorder.
> +
> +Linux traditionally had no support for a persistent, non-volatile RAM-based
> +filesystem, persistent meaning the filesystem survives a system reboot

               Persistent

> +or power cycle intact. The RAM-based filesystems such as tmpfs and ramfs
> +have no actual backing store but exist entirely in the page and buffer
> +caches, hence the filesystem disappears after a system reboot or

           Hence

> +power cycle.
> +
> +A relatively straightforward solution is to write a simple block driver
> +for the non-volatile RAM, and mount over it any disk-based filesystem such
> +as ext2, ext3, ext4, etc.
> +
> +But the disk-based fs over non-volatile RAM block driver approach has
> +some drawbacks:
> +
> +1. Complexity of disk-based fs: disk-based filesystems such as ext2/ext3/ext4
> +   were designed for optimum performance on spinning disk media, so they
> +   implement features such as block groups, which attempts to group inode data
> +   into a contiguous set of data blocks to minimize disk seeking when accessing
> +   files. For RAM there is no such concern; a file's data blocks can be
> +   scattered throughout the media with no access speed penalty at all. So block
> +   groups in a filesystem mounted over RAM just adds unnecessary
> +   complexity. A better approach is to use a filesystem specifically
> +   tailored to RAM media which does away with these disk-based features.
> +   This increases the efficient use of space on the media, i.e. more
> +   space is dedicated to actual file data storage and less to meta-data
> +   needed to maintain that file data.
> +
> +2. Different problems between disks and RAM: Because PRAMFS attempts to avoid
> +   filesystem corruption caused by kernel bugs, dirty pages in the page cache
> +   are not allowed to be written back to the backing-store RAM. This way, an
> +   errant write into the page cache will not get written back to the filesystem.
> +   However, if the backing-store RAM is comparable in access speed to system
> +   memory, the penalty of not using caching is minimal. With this consideration
> +   it's better to move file data directly between the user buffers and the backing
> +   store RAM, i.e. use direct I/O. This prevents the unnecessary populating of
> +   the page cache with dirty pages. However direct I/O has to be enabled at
> +   every file open. To enable direct I/O at all times for all regular files
> +   requires either that applications be modified to include the O_DIRECT flag on
> +   all file opens, or that the filesystem used performs direct I/O by default.
> +
> +The Persistent/Protected RAM Special Filesystem (PRAMFS) is a read/write
> +filesystem that has been designed to address these issues. PRAMFS is targeted
> +to fast I/O memory, and if the memory is non-volatile, the filesystem will be
> +persistent.
> +
> +In PRAMFS, direct I/O is enabled across all files in the filesystem, in other
> +words the O_DIRECT flag is forced on every open of a PRAMFS file. Also, file
> +I/O in the PRAMFS is always synchronous. There is no need to block the current
> +process while the transfer to/from the PRAMFS is in progress, since one of
> +the requirements of the PRAMFS is that the filesystem exists in fast RAM. So
> +file I/O in PRAMFS is always direct, synchronous, and never blocks.
> +
> +PRAMFS supports the execute-in-place. With Xip, instead of doing
> +memory-to-memory copies to transfer data from/to user space from/to kernel
> +space, read&write operations are performed directly from/to the memory. For

          read & write

> +file mappings, the RAM itself is mapped directly into userspace. Xip,
> +in addition, speed-up the applications start-up time because it removes the

                speeds up

> +needs of any copies.
> +
> +PRAMFS is write protected. The page table entries that map the backing-store
> +RAM are normally marked read-only. Write operations into the filesystem
> +temporarily mark the affected pages as writeable, the write operation is
> +carried out with locks held, and then the page table entries is

                                                                are

> +marked read-only again.
> +This feature provides protection against filesystem corruption caused by errant
> +writes into the RAM due to kernel bugs for instance. In case there are systems
> +where the write protection is not possible (for instance the RAM cannot be
> +mapped with page tables), this feature can be disabled via the
> +CONFIG_PRAMFS_WRITE_PROTECT config option and at mount time.
> +
> +PRAMFS supports extended attributes, ACLs, security labels, freezeing, the

                                                               freezing,

> +new lseek options SEEK_DATA/SEEK_HOLE and file pre-allocation (fallocate).
> +
> +In summary, PRAMFS is a light-weight special filesystem that is ideal for
> +systems with a block of fast non-volatile RAM that need to access data on it
> +using a standard filesytem interface.

                    filesystem

> +
> +Supported mount options
> +=======================
> +
> +The PRAMFS currently requires one mount option, and there are several
> +optional mount options:
> +
> +physaddr=	Required. It tells PRAMFS the physical address of the
> +		start of the RAM that makes up the filesystem. The
> +		physical address must be located on a page boundary.
> +
> +init=		Optional. It is used to initialize the memory to an
> +		empty filesystem. Any data in an existing filesystem
> +		will be lost if this option is given. The parameter to
> +		"init=" is the RAM in kilo/mega/giga bytes.
> +
> +bs=		Optional. It is used to specify a block size. It is
> +		ignored if the "init=" option is not specified, since
> +		otherwise the block size is read from the PRAMFS
> +		super-block. The default blocksize is 2048 bytes,
> +		and the allowed block sizes are 512, 1024, 2048, and
> +		4096.
> +
> +bpi=		Optional. It is used to specify the bytes per inode
> +		ratio, i.e. for every N bytes in the filesystem, an
> +		inode will be created. This behaves the same as the "-i"
> +		option to mke2fs. It is ignored if the "init=" option is
> +		not specified.
> +
> +N=		Optional. It is used to specify the number of inodes to
> +		allocate in the inode table. If the option is not
> +		specified, the bytes-per-inode ratio is used to
> +		calculate the number of inodes. If neither the "N=" or
> +		"bpi=" options are specified, the default behavior is to
> +		reserve 5% of the total space in the filesystem for the
> +		inode table. This option behaves the same as the "-N"
> +		option to mke2fs. It is ignored if the "init=" option is
> +		not specified.
> +
> +errors=		Optional. It can be "cont", "remount-ro" and "panic". With the

                                                                 or

> +		first value no action is done in case of error. With the second
> +		one the fs is mounted read-only. with the third one a kernel
> +		panic happens. Default action is to continue on error.
> +
> +acl,noacl	Optional. Enable/disable the support for access control lists
> +		(disabled by default).
> +
> +user_xattr,	Optional. Enable/disable the support for the user extended
> +user_noxattr	attributes (disabled by default).
> +
> +noprotect	Optional. Disable the memory protection (enabled by default).
> +
> +xip		Optional. Enable the execute-in-place (disabled by default).
> +
> +Examples:
> +
> +mount -t pramfs -o physaddr=0x20000000,init=1M,bs=1k none /mnt/pram
> +
> +This example locates the filesystem at physical address 0x20000000, and
> +also requests an empty filesystem be initialized, of total size of one
> +megabyte and blocksize of one kilobyte. The mount point is /mnt/pram.
> +
> +mount -t pramfs -o physaddr=0x20000000 none /mnt/pram
> +
> +This example locates the filesystem at physical address 0x20000000 as in
> +the first example, but uses the intact filesystem that already exists.
> +
> +Current Limitations
> +===================
> +
> +- The RAM used for PRAMFS must be directly addressable.
> +
> +- PRAMFS does not support hard links.
> +
> +- PRAMFS supports only private memory mappings. This allows most
> +  executables to run, but programs that attempt shared memory
> +  mappings, such as X apps that use X shared memory, will fail.
> +
> +- PRAMFS does not support quota settings.
> +
> +Further Documentation
> +=====================
> +
> +If you are interested in the internal design of PRAMFS, there is
> +documentation available at the Sourceforge PRAMFS home page at
> +http://pramfs.sourceforge.net/.
> +
> +Please send bug reports/comments/feedback to the pramfs development
> +list at sourceforge: pramfs-devel@lists.sourceforge.net.


-- 
~Randy
