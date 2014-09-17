Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaIQNUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:20:39 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60265 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755257AbaIQNUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:20:37 -0400
Date: Wed, 17 Sep 2014 14:20:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@denx.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dinh Nguyen <dinh.linux@gmail.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Dinh Nguyen <dinguyen@altera.com>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 3.17-rc2: root=/dev/mmcblk0p2 command line parsing fails
Message-ID: <20140917132002.GS12361@n2100.arm.linux.org.uk>
References: <1405397216-909-1-git-send-email-dinguyen@altera.com> <53C4D874.2040206@samsung.com> <20140814184710.GA11558@amd.pavel.ucw.cz> <53ED2262.50604@gmail.com> <20140814210252.GB26857@amd.pavel.ucw.cz> <20140826114707.GA16372@amd> <CADhT+wdx2SsHnk=zML7a6mUVJxvLQ9ARO16QoYYsopAqhw7cow@mail.gmail.com> <20140909114941.GE15404@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909114941.GE15404@amd>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 01:49:41PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > The problem is still there in 3.17-rc2. 3.16 does not have the
> > > problem. Messages are still similar:
> > >
> > > mmc0: new high speed SDHC card at address b368
> > > mmcblk0: mmc0:b368 USD   7.45 GiB
> > >  mmcblk0: p1 p2 p3 p4
> > > VFS: Cannot open root device "mmcblk0p2" or unknown-block(0,0): error
> > > -6
> > > Please append a correct "root=" boot option; here are the available
> > > partitions:
> > > b300         7822336 mmcblk0  driver: mmcblk
> > >   b301          102400 mmcblk0p1 00082434-01
> > >   b302         1048576 mmcblk0p2 00082434-02
> > >   b303            1024 mmcblk0p3 00082434-03
> > >   b304         6086656 mmcblk0p4 00082434-04
> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> > > 3.17.0-rc2-00368-gec0400b-dirty #83
> > >
> > >
> > > What is going on there? Clearly partition table was parsed and
> > > partitions are available; does the mention of unknown-block(0,0) mean
> > > that kernel failed to parse the command line?
> > >
> > > I replaced "root=/dev/mmcblk0p2" with "root=b302" and have a booting
> > > system.
> > 
> > 
> > Can you do a bisect? 3.17-rc2 booted fine for me today:
> > 
> > EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
> > VFS: Mounted root (ext3 filesystem) on device 179:2.
> > Freeing unused kernel memory: 252K (c052d000 - c056c000)
> > random: nonblocking pool is initialized
> 
> Bisect would be hard... and I believe the problem is somewhere in
> block layer now -- not socfpga-specific.

[Adding those on the commit mentioned below to this thread.]

I just updated my nightly build system from -rc3 to -rc5, and I'm seeing
this on the LDP3430 platform (but not the SDP4430) despite both using
MMC rootfs.

On SD4430, I see:

Kernel command line: root=/dev/mmcblk0p2 rw mem=512M vmalloc=1G console=ttyO2,115200n8 rootdelay=2 debug
...
mmc0: new high speed SD card at address 0002
mmcblk0: mmc0:0002 00000 971 MiB
 mmcblk0: p1 p2
leds_pwm pwmleds: unable to request PWM for omap4:green:chrg: -517
platform pwmleds: Driver leds_pwm requests probe deferral
Waiting 2 sec before mounting root device...
mmc1: new high speed MMC card at address 0001
mmcblk1: mmc1:0001 SEM08G 7.39 GiB
mmcblk1boot0: mmc1:0001 SEM08G partition 1 1.00 MiB
mmcblk1boot1: mmc1:0001 SEM08G partition 2 1.00 MiB
 mmcblk1: unknown partition table
 mmcblk1boot1: unknown partition table
 mmcblk1boot0: unknown partition table
leds_pwm pwmleds: unable to request PWM for omap4:green:chrg: -517
platform pwmleds: Driver leds_pwm requests probe deferral
kjournald starting.  Commit interval 5 seconds
EXT3-fs (mmcblk0p2): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (mmcblk0p2): using internal journal
EXT3-fs (mmcblk0p2): recovery complete
EXT3-fs (mmcblk0p2): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) on device 179:2.

However, on LDP3430:

Kernel command line: console=ttyO2,115200n8 noinitrd vmalloc=1G mem=128M root=/dev/mmcblk0p2 rw ip=none rootdelay=2 video=omap24xxfb:rotation=270
...
mmc0: host does not support reading read-only switch. assuming write-enable.
Waiting 2 sec before mounting root device...
mmc0: new high speed SD card at address 0002
mmcblk0: mmc0:0002 00000 971 MiB
 mmcblk0: p1 p2
VFS: Cannot open root device "mmcblk0p2" or unknown-block(0,0): error -6
Please append a correct "root=" boot option; here are the available partitions:
b300          994816 mmcblk0  driver: mmcblk
  b301           72261 mmcblk0p1 0b4c6c45-01
  b302          915705 mmcblk0p2 0b4c6c45-02
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

I think the problem may be 4dfe694f616e00e6fd83e5bbcd7a3c4d7113493d
("init: make rootdelay=N consistent with rootwait behaviour") which
was merged during the recent window.  This moved the delay after the
saved_root_name[] handling.  As we can see in the SDP4430 case, the
order was:

 - mmcblk0p2 detected
 - delay message
 - rootfs failure

and everything worked.  However, in the LDP3430 case:

 - delay message
 - mmcblk0p2 detected
 - rootfs failure

and it failed.  If we look at the code as it stands today:

        if (saved_root_name[0]) {
                root_device_name = saved_root_name;
                if (!strncmp(root_device_name, "mtd", 3) ||
                    !strncmp(root_device_name, "ubi", 3)) {
                        mount_block_root(root_device_name, root_mountflags);
                        goto out;
                }
                ROOT_DEV = name_to_dev_t(root_device_name);
                if (strncmp(root_device_name, "/dev/", 5) == 0)
                        root_device_name += 5;
        }

This tries to look up the root device name and translate to a dev_t.
We know that "mmcblk0p2" doesn't exist at this point, so ROOT_DEV is
zero here.

        if (initrd_load())
                goto out;

        if (root_delay) {
                pr_info("Waiting %d sec before mounting root device...\n",
                        root_delay);
                ssleep(root_delay);
        }

Here's our delay.

        /* wait for any asynchronous scanning to complete */
        if ((ROOT_DEV == 0) && root_wait) {
                printk(KERN_INFO "Waiting for root device %s...\n",
                        saved_root_name);
                while (driver_probe_done() != 0 ||
                        (ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
                        msleep(100);
                async_synchronize_full();
        }

If ROOT_DEV was still zero, and root_wait was set (it isn't) we'd then
try to re-evaluate ROOT_DEV.  ROOT_DEV must be set to mount the rootfs,
and we can see from the above failure messages that it was still zero.
That works out, because this code would never be run with root_wait=false.

The reason it used to work is because the delay came _before_ the first
"if" above, so causing the first ROOT_DEV lookup to succeed.

I think it may be better to move the root_delay handling either immediately
after md_run_setup(), or we need to re-lookup ROOT_DEV after the delay.
Paul, any thoughts?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
