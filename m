Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3HGNeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:34:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab3HGNeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:34:14 -0400
Date: Wed, 7 Aug 2013 15:34:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-input@vger.kernel.org, Manoj Chourasia <mchourasia@nvidia.com>,
        linux-kernel@vger.kernel.org, alnovak@suse.cz
Subject: Re: List corruption in hidraw_release in 3.11-rc4
In-Reply-To: <6207700.eHyYqS01s0@al>
Message-ID: <alpine.LNX.2.00.1308071533130.10425@pobox.suse.cz>
References: <6712128.bn50J4si9x@al> <alpine.LNX.2.00.1308070258480.10817@pobox.suse.cz> <6207700.eHyYqS01s0@al>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Peter Wu wrote:

> > does the patch below fix the problem you are seeing?
> That one is already in 3.11-rc4 as far as I can see. Also, that code can 
> probably simplified by moving the mutex_unlock after the out label, removing 
> the need to duplicate the mutex_unlock.
> 
> Remember what I said about "no Oopses"? Well, it turned out that several 
> memory structures were damaged which causes a general protection fault in 
> sock_alloc_inode and other places.
> 
> I managed to create a program that can reproduce this bug 100% in a QEMU 
> virtual machine with a Logitech USB receiver passed to it.
> 
> qemu-system-x86_64 -enable-kvm -m 1G -usb -usbdevice host:046d:c52b
> (pass -kernel, -initrd, -append as needed)
> 
> Copy hidraw-test to initrd, boot QEMU and run `hidraw-test`. Result: instant
> (= +/- 2 seconds) crash.
> 
> I have applied Manoj's patch[1] on top of 3.11-rc4 which seem to fix the issue. 
> One observation is that the new device is named /dev/hidraw1 instead of 
> /dev/hidraw0. Example:
> 
> f(){ hidraw-test /dev/hidraw$1 usb1;}
> # needed for 3.11-rc4
> f 1; f 1 # crash
> # needed for 3.11-rc4 + patch
> f 1; f 2 # ok
> 
> Regards,
> Peter
> 
>  [1]: http://lkml.org/lkml/2013/7/22/248

That one I am still reviewing ... can I add your Tested-by: to it when 
I'll be applying it and pushing to Linus?

Thanks.

> --
> /* cc hidraw-test.c -o hidraw-test
>  * hidraw-test /dev/hidraw0 usb1; hidraw-test /dev/hidraw0 usb1;
>  */
> #include <unistd.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <errno.h>
> #include <string.h>
> #include <stdlib.h>
> 
> int open_and_write(const char *path, const char *data) {
> 	int sfd, r;
> 
> 	sfd = open(path, O_WRONLY);
> 	if (sfd < 0) {
> 		perror(path);
> 		return 1;
> 	}
> 
> 	r = write(sfd, data, strlen(data));
> 	if (r < 0) {
> 		fprintf(stderr, "write(%s, %s): %s\n",
> 			path, data, strerror(errno));
> 		return 1;
> 	}
> 	close(sfd);
> 	return 0;
> }
> 
> int dork(const char *hiddev, const char *name) {
> 	int fd;
> 	char c;
> 
> 	fd = open(hiddev, O_RDWR | O_NONBLOCK);
> 	if (fd < 0) {
> 		perror("open");
> 		return 1;
> 	}
> 
> 	if (open_and_write("/sys/bus/usb/drivers/usb/unbind", name))
> 		return 1;
> 
> 	// does not make a difference
> 	//sleep(1);
> 
> 	if (open_and_write("/sys/bus/usb/drivers/usb/bind", name))
> 		return 1;
> 
> 	// allow devices to get discovered
> 	sleep(1);
> 
> 	printf("read() = %zi\n", read(fd, &c, 1)); perror("read");
> 	close(fd);
> 	return 0;
> }
> 
> int main(int argc, char **argv) {
> 	if (argc < 3) {
> 		fprintf(stderr, "Usage: %s /dev/hidrawN usbN\n", *argv);
> 		return 1;
> 	}
> 
> 	system("modprobe -v usbhid");
> 	system("modprobe -v hid-logitech-dj");
> 
> 	dork(argv[1], argv[2]);
> 
> 	return 0;
> }
> 

-- 
Jiri Kosina
SUSE Labs
