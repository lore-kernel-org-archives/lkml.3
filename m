Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaFPI3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:29:05 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64462 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaFPI3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:29:03 -0400
Date: Mon, 16 Jun 2014 16:28:55 +0800
From: Real Name <enjoymindful@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
Message-ID: <20140616082855.GB1840@name>
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
 <539C1964.4050504@nod.at>
 <20140616032852.GA1763@name>
 <539E93B9.5070407@nod.at>
 <20140616081238.GA1840@name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140616081238.GA1840@name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:12:38PM +0800, Real Name wrote:
> On Mon, Jun 16, 2014 at 08:50:33AM +0200, Richard Weinberger wrote:
> > 
> > 
> > Am 16.06.2014 05:28, schrieb Real Name:
> > > On Sat, Jun 14, 2014 at 11:44:04AM +0200, Richard Weinberger wrote:
> > >> Hi!
> > >>
> > >> Am 03.06.2014 07:30, schrieb Real Name:
> > >>> From: Honggang Li <enjoymindful@gmail.com>
> > >>>
> > >>> The patch based on linux-next-2014-06-02.
> > >>>
> > >>> The old init_maps function does two things:
> > >>> 1) allocates and initializes one struct page array for bootmem
> > >>> 2) count the number of total pages
> > >>>
> > >>> After removed the source code related to the unnecessary array, the name 
> > >>> 'init_maps' is some kind of improper named, as it just count the number of
> > >>> total page numbers. So, I renamed the function as 'mem_total_pages'.
> > >>>
> > >>> I tested the patch through repeat reboot the uml kernel many times.
> > >>> [real@name linux-next]$ make ARCH=um defconfig
> > >>> [real@name linux-next]$ make ARCH=um linux
> > >>> [real@name linux-next]$ file linux
> > >>> linux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, not stripped
> > >>> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 1
> > >>> [real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 2
> > >>> (repeat reboot the uml kernel many times..)
> > >>
> > >> Can you please include in the changelog the commit sha1 which made the old init_maps() obsolete?

I think we need find out which commit deleted the line "mem_map = map;" in init_maps function.

> > >> I had a look at the pre-git linux tree, looks like init_maps() wasn't touched for more than 10 years.
> > > 
> > > hi, richard
> > > 
> > > what is the pre-git linux tree? I searched it with google, but failed.
> > > 
> > > The v2.6.12 kernel is the oldest one available from the linux-next git tree. And it has duplicated
> > > struct page arrays. So, any suggestion how to find the commit you wanted?
> >
>  
> > https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git
> 
> richard, geert, and paul
> thanks all of you for the git-pre info.
> 
> > 
> > > linux-2.4.20 + uml-patch-2.4.20-8 works on *old* redhat-9 virtual machine. And it seems has duplicated
> > > struct page array too.
> > >
> > 
> > And if you remove it here too UML still works?
> 
> yes, it works. I removed the code related struct page array in init_maps.
> 
> Please check the attachments.
> 
> [root@rht9 root]# /root/linux-2.4.20/linux ubda=/root/uml/root_fs.rh-7.2-server.pristine.20020312 mem=256m 2>&1 | tee /tmp/log.txt
> 
> thanks
> 
> > 
> > Thanks,
> > //richard
> > 
> > > The first struct page array
> > > ------------------------
> > > linux-2.4.20/arch/um/kernel/physmem.c
> > > 157 int init_maps(unsigned long len)
> > > 158 {
> > > 159         struct page *p, *map;
> > > 160         int i, n;
> > > 161 
> > > 162         n = len >> PAGE_SHIFT;
> > > 163         len = n * sizeof(struct page);
> > > 164 
> > > 165         if(kmalloc_ok){
> > > 166                 map = kmalloc(len, GFP_KERNEL);
> > > 167                 if(map == NULL) map = vmalloc(len);
> > > 168         }
> > > 169         else map = alloc_bootmem_low_pages(len);
> > > 170 
> > > 171         if(map == NULL)
> > > 172                 return(-ENOMEM);
> > > 173 
> > > 174         for(i = 0; i < n; i++){
> > > 175                 p = &map[i];
> > > 176                 set_page_count(p, 0);
> > > 177                 SetPageReserved(p);
> > > 178                 INIT_LIST_HEAD(&p->list);
> > > 179         }
> > > 180 
> > > 181         mem_map = map;
> > > 182         max_mapnr = n;
> > > 183         return(0);
> > > 184 }
> > > 
> > > 
> > > The second struct page array
> > > -----------------------
> > > mm/memory.c
> > > 73 mem_map_t * mem_map; // global define
> > > 
> > > mm/page_alloc.c
> > > 839 void __init free_area_init(unsigned long *zones_size)
> > > 840 {
> > > 841         free_area_init_core(0, &contig_page_data, &mem_map, zones_size, 0, 0, 0);
> > > 842 }
> > > 
> > > --------
> > > mm/page_alloc.c
> > > 685 void __init free_area_init_core(int nid, pg_data_t *pgdat, struct page **gmap,
> > > 686         unsigned long *zones_size, unsigned long zone_start_paddr,
> > > 687         unsigned long *zholes_size, struct page *lmem_map)
> > > 688 {
> > > ........
> > > 716         map_size = (totalpages + 1)*sizeof(struct page);
> > > 717         if (lmem_map == (struct page *)0) {
> > > 718                 lmem_map = (struct page *) alloc_bootmem_node(pgdat, map_size);
> > > 719                 lmem_map = (struct page *)(PAGE_OFFSET +
> > > 720                         MAP_ALIGN((unsigned long)lmem_map - PAGE_OFFSET));
> > > 721         }
> > > 722         *gmap = pgdat->node_mem_map = lmem_map;
> > > 
> > > 
> > >>
> > >> Thanks,
> > >> //richard
> > >>
> > >>> Honggang Li (1):
> > >>>   delete unnecessary bootmem struct page array
> > >>>
> > >>>  arch/um/include/shared/mem_user.h |  2 +-
> > >>>  arch/um/kernel/physmem.c          | 32 ++++++--------------------------
> > >>>  arch/um/kernel/um_arch.c          |  7 +------
> > >>>  3 files changed, 8 insertions(+), 33 deletions(-)
> > >>>

> --- physmem.c.old	2014-06-16 07:35:27.000000000 -0400
> +++ physmem.c	2014-06-16 07:40:38.000000000 -0400
> @@ -156,29 +156,10 @@
>  
>  int init_maps(unsigned long len)
>  {
> -	struct page *p, *map;
> -	int i, n;
> +	int n;
>  
>  	n = len >> PAGE_SHIFT;
> -	len = n * sizeof(struct page);
>  
> -	if(kmalloc_ok){
> -		map = kmalloc(len, GFP_KERNEL);
> -		if(map == NULL) map = vmalloc(len);
> -	}
> -	else map = alloc_bootmem_low_pages(len);
> -
> -	if(map == NULL)
> -		return(-ENOMEM);
> -
> -	for(i = 0; i < n; i++){
> -		p = &map[i];
> -		set_page_count(p, 0);
> -		SetPageReserved(p);
> -		INIT_LIST_HEAD(&p->list);
> -	}
> -
> -	mem_map = map;
>  	max_mapnr = n;
>  	return(0);
>  }

> Checking for the skas3 patch in the host...not found
> Checking for /proc/mm...not found
> Kernel virtual memory size shrunk to 243269632 bytes
> Linux version 2.4.20-8um (root@rht9) (gcc version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)) #2 Mon Jun 16 07:41:28 EDT 2014
> On node 0 totalpages: 65536
> zone(0): 65536 pages.
> zone(1): 0 pages.
> zone(2): 0 pages.
> Kernel command line: ubda=/root/uml/root_fs.rh-7.2-server.pristine.20020312 mem=256m root=/dev/ubd0
> Calibrating delay loop... 6829.32 BogoMIPS
> Memory: 256152k available
> Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
> Inode cache hash table entries: 16384 (order: 5, 131072 bytes)
> Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
> Buffer-cache hash table entries: 16384 (order: 4, 65536 bytes)
> Page-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Checking for host processor cmov support...Yes
> Checking for host processor xmm support...No
> Checking that ptrace can change system call numbers...OK
> Checking that host ptys support output SIGIO...Yes
> Checking that host ptys support SIGIO on close...No, enabling workaround
> POSIX conformance testing by UNIFIX
> Linux NET4.0 for Linux 2.4
> Based upon Swansea University Computer Society NET3.039
> Initializing RT netlink socket
> Starting kswapd
> VFS: Diskquotas version dquot_6.4.0 initialized
> devfs: v1.12c (20020818) Richard Gooch (rgooch@atnf.csiro.au)
> devfs: boot_options: 0x1
> JFFS version 1.0, (C) 1999, 2000  Axis Communications AB
> JFFS2 version 2.1. (C) 2001 Red Hat, Inc., designed by Axis Communications AB.
> pty: 256 Unix98 ptys configured
> SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
> RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
> loop: loaded (max 8 devices)
> PPP generic driver version 2.4.2
> Universal TUN/TAP device driver 1.5 (C)1999-2002 Maxim Krasnyansky
> SCSI subsystem driver Revision: 1.00
> scsi0 : scsi_debug, Version: 0.61 (20020815), num_devs=1, dev_size_mb=8, opts=0x0
>   Vendor: Linux     Model: scsi_debug        Rev: 0004
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> blkmtd: error, missing `device' name
> Initializing software serial port version 1
> mconsole (version 2) initialized on /root/.uml/rdspmA/mconsole
> Partition check:
>  ubda: unknown partition table
> UML Audio Relay (host dsp = /dev/sound/dsp, host mixer = /dev/sound/mixer)
> Initializing stdio console driver
> NET4: Linux TCP/IP 1.0 for NET4.0
> IP Protocols: ICMP, UDP, TCP
> IP: routing cache hash table of 2048 buckets, 16Kbytes
> TCP: Hash tables configured (established 16384 bind 32768)
> NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
> VFS: Mounted root (ext2 filesystem) readonly.
> Mounted devfs on /dev
> 
INIT: version 2.78 booting
> 			Welcome to Red Hat Linux
> 		Press 'I' to enter interactive startup.
> Mounting proc filesystem:  [  OK  ]
> Configuring kernel parameters:  [  OK  ]
> Setting clock : Mon Jun 16 08:02:25 EDT 2014 [  OK  ]
> Activating swap partitions:  [  OK  ]
> Setting hostname redhat72.goober.org:  [  OK  ]
> Checking root filesystem
> /dev/ubd/0: clean, 38751/64768 files, 212070/259072 blocks
> [/sbin/fsck.ext2 (1) -- /] fsck.ext2 -a /dev/ubd/0 
> [  OK  ]
> Remounting root filesystem in read-write mode:  [  OK  ]
> Finding module dependencies:  depmod: cannot read ELF header from /lib/modules/2.4.20-8um/modules.dep
> depmod: cannot read ELF header from /lib/modules/2.4.20-8um/modules.generic_string
> depmod: /lib/modules/2.4.20-8um/modules.ieee1394map is not an ELF file
> depmod: /lib/modules/2.4.20-8um/modules.isapnpmap is not an ELF file
> depmod: cannot read ELF header from /lib/modules/2.4.20-8um/modules.parportmap
> depmod: /lib/modules/2.4.20-8um/modules.pcimap is not an ELF file
> depmod: cannot read ELF header from /lib/modules/2.4.20-8um/modules.pnpbiosmap
> depmod: /lib/modules/2.4.20-8um/modules.usbmap is not an ELF file
> [FAILED]
> Checking filesystems
> Checking all file systems.
> [  OK  ]
> Mounting local filesystems:  [  OK  ]
> Enabling local filesystem quotas:  [  OK  ]
> swapon: cannot stat /dev/ubd/1: No such file or directory
> Enabling swap space:  [  OK  ]
> 
INIT: Entering runlevel: 3
> Entering non-interactive startup
> Setting network parameters:  [  OK  ]
> Bringing up interface lo:  [  OK  ]
> SIOCADDRT: No such device
> SIOCADDRT: Network is unreachable
> Starting system logger: [  OK  ]
> Starting kernel logger: [  OK  ]
> Starting portmapper: [  OK  ]
> Initializing random number generator:  [  OK  ]
> Mounting other filesystems:  [  OK  ]
> Starting identd: [  OK  ]
> Starting snmpd: [  OK  ]
> Starting named: [  OK  ]
> Starting sshd:  [  OK  ]
> Starting xinetd: [  OK  ]
> Starting sendmail: [  OK  ]
> Starting httpd: [  OK  ]
> Starting crond: [  OK  ]
> Starting squid:  [  OK  ]
> Starting SMB services: [  OK  ]
> Starting NMB services: [  OK  ]
> Please run makehistory and/or makedbz before starting innd.
> Running Linuxconf hooks:  [  OK  ]
> c
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: Warning: This program is an suid-root program or is being run by the root user.
> The full text of the error or warning message cannot be safely formatted
> in this environment. You may get a more descriptive message by running the
> program as a non-root user or by removing the suid bit on the executable.
> xterm Xt error: Can't open display: %s
> Warning: This program is an suid-root program or is being run by the root user.
> The full text of the error or warning message cannot be safely formatted
> in this environment. You may get a more descriptive message by running the
> program as a non-root user or by removing the suid bit on the executable.
> xterm Xt error: Can't open display: %s
> 
> 
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: 
> 
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: root
> Password: 
> Last login: Mon Jun 16 08:00:06 on vc/0
> bash-2.05# /sbin/poweroff 
> 
> Broadcast message from root (vc/0) Mon Jun 16 08:03:17 2014...
> 
> 
The system is going down for system halt NOW !!
> 
INIT: Switching to runlevel: 0
> 
INIT: Sending processes the TERM signal
> bash-2.05# 
INIT: Sending processes the KILL signal
> 
INIT: Pid 527 [id 1] seems to hang
> 
INIT: Pid 528 [id 2] seems to hang
> Stopping httpd: [  OK  ]
> Stopping squid:  [  OK  ]
> Stopping sshd:[  OK  ]
> Shutting down sendmail: [  OK  ]
> Shutting down SMB services: [  OK  ]
> Shutting down NMB services: [FAILED]
> Stopping named: [  OK  ]
> Stopping snmpd: [  OK  ]
> Stopping xinetd: [  OK  ]
> Stopping crond: [  OK  ]
> Stopping identd: [  OK  ]
> Saving random seed:  [  OK  ]
> Stopping portmapper: [  OK  ]
> Shutting down kernel logger: [  OK  ]
> Shutting down system logger: [  OK  ]
> Starting killall:  Shutting down SMB services: [FAILED]
> Shutting down NMB services: [FAILED]
> [FAILED]
> Sending all processes the TERM signal... 
> Sending all processes the KILL signal... 
> Syncing hardware clock to system time 
> Turning off quotas:  
> umount2: Device or resource busy
> umount: devfs: not found
> umount: /dev: Illegal seek
> Halting system...
> Power down.
> tracing thread pid = 11409
> 

> [root@rht9 linux-2.4.20]# objdump -S -d linux > linux_source.s
> [root@rht9 linux-2.4.20]# vim linux_source.s	
> 	 472789 a00d7acc <to_phys>:
> 	 472790 a00d7acc:       55                      push   %ebp
> 	 472791 a00d7acd:       89 e5                   mov    %esp,%ebp
> 	 472792 a00d7acf:       8b 45 08                mov    0x8(%ebp),%eax
> 	 472793 a00d7ad2:       2b 05 e0 60 25 a0       sub    0xa02560e0,%eax
> 	 472794 a00d7ad8:       c9                      leave
> 	 472795 a00d7ad9:       c3                      ret
> 	 472796 a00d7ada:       89 f6                   mov    %esi,%esi
> 	 472797
> 	 472798 a00d7adc <init_maps>:
> 	 472799 a00d7adc:       55                      push   %ebp
> 	 472800 a00d7add:       89 e5                   mov    %esp,%ebp
> 	 472801 a00d7adf:       8b 45 08                mov    0x8(%ebp),%eax
> 	 472802 a00d7ae2:       c1 e8 0c                shr    $0xc,%eax
> 	 472803 a00d7ae5:       a3 e0 43 23 a0          mov    %eax,0xa02343e0
> 	 472804 a00d7aea:       31 c0                   xor    %eax,%eax
> 	 472805 a00d7aec:       c9                      leave
> 	 472806 a00d7aed:       c3                      ret
> 	 472807 a00d7aee:       89 f6                   mov    %esi,%esi
> 	 472808
> 	 472809 a00d7af0 <__virt_to_page>:
> 	 472810 a00d7af0:       55                      push   %ebp
> 	 472811 a00d7af1:       89 e5                   mov    %esp,%ebp
> 	 472812 a00d7af3:       8b 55 08                mov    0x8(%ebp),%edx
> 	 472813 a00d7af6:       2b 15 e0 60 25 a0       sub    0xa02560e0,%edx
> 	 472814 a00d7afc:       c1 ea 0c                shr    $0xc,%edx
> 	

> [root@rht9 root]# 
> [root@rht9 root]# uname -a
> Linux rht9 2.4.25 #2 SMP Mon Jun 9 03:21:50 EDT 2014 i686 i686 i386 GNU/Linux
> 
> 
> 
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: Warning: This program is an suid-root program or is being run by the root user.
> The full text of the error or warning message cannot be safely formatted
> in this environment. You may get a more descriptive message by running the
> program as a non-root user or by removing the suid bit on the executable.
> xterm Xt error: Can't open display: %s
> Warning: This program is an suid-root program or is being run by the root user.
> The full text of the error or warning message cannot be safely formatted
> in this environment. You may get a more descriptive message by running the
> program as a non-root user or by removing the suid bit on the executable.
> xterm Xt error: Can't open display: %s
> 
> 
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: 
> 
> Unauthorized access to this system is strictly prohibited.
> redhat72 login: root
> Password: 
> Last login: Mon Jun 16 07:56:47 on vc/0
> bash-2.05#       
> bash-2.05# 
> bash-2.05# 
> bash-2.05# cat /proc/cpuinfo 
> processor  : 0
> vendor_id  : User Mode Linux
> model name : UML
> mode  	   : tt
> host	     : Linux rht9 2.4.25 #2 SMP Mon Jun 9 03:21:50 EDT 2014 i686
> bogomips     : 6816.66
> 
> bash-2.05# 
> bash-2.05# 
> bash-2.05# uname -a
> Linux redhat72.goober.org 2.4.20-8um #2 Mon Jun 16 07:41:28 EDT 2014 i686 unknown
> bash-2.05# 
> bash-2.05# 
> bash-2.05# /sbin/poweroff 
> 
> Broadcast message from root (vc/0) Mon Jun 16 08:00:23 2014...
> 
> The system is going down for system halt NOW !!
> INIT: Switching to runlevel: 0
> INIT: Sending processes the TERM signal
> INIT: Sending processes the KILL signal
> INIT: Pid 520 [id 1] seems to hang
> INIT: Pid 521 [id 2] seems to hang
> Stopping httpd: [  OK  ]
> Stopping squid:  [  OK  ]
> Stopping sshd:[  OK  ]
> Shutting down sendmail: [  OK  ]
> Shutting down SMB services: [  OK  ]
> Shutting down NMB services: [FAILED]
> Stopping named: [  OK  ]
> Stopping snmpd: [  OK  ]
> Stopping xinetd: [  OK  ]
> Stopping crond: [  OK  ]
> Stopping identd: [  OK  ]
> Saving random seed:  [  OK  ]
> Stopping portmapper: [  OK  ]
> Shutting down kernel logger: [  OK  ]
> Shutting down system logger: [  OK  ]
> Starting killall:  Shutting down SMB services: [FAILED]
> Shutting down NMB services: [FAILED]
> [FAILED]
> Sending all processes the TERM signal... 
> Sending all processes the KILL signal... 
> Syncing hardware clock to system time 
> Turning off quotas:  
> umount2: Device or resource busy
> umount: devfs: not found
> umount: /dev: Illegal seek
> Halting system...
> Power down.
> 
> [root@rht9 root]# 

