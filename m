Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3HGPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:06:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6204 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3HGPGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:06:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Aug 2013 08:06:45 -0700
From: Manoj Chourasia <mchourasia@nvidia.com>
To: Jiri Kosina <jkosina@suse.cz>, Peter Wu <lekensteyn@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alnovak@suse.cz" <alnovak@suse.cz>
Date: Wed, 7 Aug 2013 20:36:40 +0530
Subject: RE: List corruption in hidraw_release in 3.11-rc4
Thread-Topic: List corruption in hidraw_release in 3.11-rc4
Thread-Index: Ac6TcsPZs83m+iXbThaXSxw1wY8PqwAC+RMw
Message-ID: <F17EA9D408D3644C864D33B8F5E1CC526DAC4BDA59@BGMAIL02.nvidia.com>
References: <6712128.bn50J4si9x@al>
 <alpine.LNX.2.00.1308070258480.10817@pobox.suse.cz> <6207700.eHyYqS01s0@al>
 <alpine.LNX.2.00.1308071533130.10425@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1308071533130.10425@pobox.suse.cz>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

The patch I posted was solving slab memory corruption issue which was occurring because of the race in device disconnect and device release. We found the some of the device data structure being used after free. Later we figure out the patch which was reverted earlier was solving our issue but there was still some slab memory corruption.  That was due to reason that list delete of the device was called after freeing the hidraw. I protect drop_ref by mutex lock and also delete the list before calling drop_ref that solve the issue. If you are seeing memory corruption then the patch could solve your issue.

Regards
-Manoj

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Wednesday, August 07, 2013 7:04 PM
To: Peter Wu
Cc: linux-input@vger.kernel.org; Manoj Chourasia; linux-kernel@vger.kernel.org; alnovak@suse.cz
Subject: Re: List corruption in hidraw_release in 3.11-rc4

On Wed, 7 Aug 2013, Peter Wu wrote:

> > does the patch below fix the problem you are seeing?
> That one is already in 3.11-rc4 as far as I can see. Also, that code 
> can probably simplified by moving the mutex_unlock after the out 
> label, removing the need to duplicate the mutex_unlock.
> 
> Remember what I said about "no Oopses"? Well, it turned out that 
> several memory structures were damaged which causes a general 
> protection fault in sock_alloc_inode and other places.
> 
> I managed to create a program that can reproduce this bug 100% in a 
> QEMU virtual machine with a Logitech USB receiver passed to it.
> 
> qemu-system-x86_64 -enable-kvm -m 1G -usb -usbdevice host:046d:c52b 
> (pass -kernel, -initrd, -append as needed)
> 
> Copy hidraw-test to initrd, boot QEMU and run `hidraw-test`. Result: 
> instant (= +/- 2 seconds) crash.
> 
> I have applied Manoj's patch[1] on top of 3.11-rc4 which seem to fix the issue. 
> One observation is that the new device is named /dev/hidraw1 instead 
> of /dev/hidraw0. Example:
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

That one I am still reviewing ... can I add your Tested-by: to it when I'll be applying it and pushing to Linus?

Thanks.

> --
> /* cc hidraw-test.c -o hidraw-test
>  * hidraw-test /dev/hidraw0 usb1; hidraw-test /dev/hidraw0 usb1;  */ 
> #include <unistd.h> #include <fcntl.h> #include <stdio.h> #include 
> <errno.h> #include <string.h> #include <stdlib.h>
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
