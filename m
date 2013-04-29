Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3D2Pey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:34:54 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:16998 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab3D2Pex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:34:53 -0400
Date: Mon, 29 Apr 2013 17:34:50 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130429153450.GA25581@frolo.macqel>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be> <1366924229-21569-3-git-send-email-phdm@macqel.be> <20130429093756.GB12317@x2.net.home> <20130429114041.GA10884@frolo.macqel> <20130429123651.GA2400@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429123651.GA2400@x2.net.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karel

On Mon, Apr 29, 2013 at 02:36:51PM +0200, Karel Zak wrote:
> On Mon, Apr 29, 2013 at 01:40:41PM +0200, Philippe De Muyter wrote:
> > > why not memset(pps_found, ....)? I also see magical constant 16
> > 
> > Actually 16 is the maximum partition count allowed in a disk by linux,
> > or should it be 15 ?  Is there already a constant for that ?
> > The AIX disk I tested with had only :) 11 partitions.
> 
> I don't think it's correct to expect any hardcoded limit. 
>  
> The struct parsed_partitions->parts is allocated according to
> disk_max_parts() where the limit depends on number of minor numbers or
> it's DISK_MAX_PARTS (=256).
> 
> There is no problem to create disk with many partitions:
> 
>  # modprobe scsi_debug dev_size_mb=300
>  # (echo -e 'g\n'; for i in {1..100}; do echo -e "n\n\n\n+1M"; done; \
>     echo -e 'w\nq\n') | fdisk /dev/sdb
> 
>  # lsblk -n /dev/sdb | wc -l
>  101

how are they named then ?

on my system (a 2.6.24 kernel which is the last one that support my
powerpc PReP machine because PReP support got removed with the merge
of /arch/ppc and /arch/powerpc :( ), I get :

root:~# ls -l /dev/sd[ab]*
brw-r----- 1 root disk 8,  0 Apr 25 22:22 /dev/sda
brw-r----- 1 root disk 8, 10 Apr 25 22:22 /dev/sda10
brw-r----- 1 root disk 8, 11 Apr 25 22:22 /dev/sda11
brw-r----- 1 root disk 8,  3 Apr 25 22:22 /dev/sda3
brw-r----- 1 root disk 8,  4 Apr 25 22:22 /dev/sda4
brw-r----- 1 root disk 8,  5 Apr 25 22:22 /dev/sda5
brw-r----- 1 root disk 8,  6 Apr 25 22:22 /dev/sda6
brw-r----- 1 root disk 8,  7 Apr 25 22:22 /dev/sda7
brw-r----- 1 root disk 8,  8 Apr 25 22:22 /dev/sda8
brw-r----- 1 root disk 8,  9 Apr 25 22:22 /dev/sda9
brw-r----- 1 root disk 8, 16 Apr 25 22:22 /dev/sdb
brw-r----- 1 root disk 8, 26 Apr 25 22:22 /dev/sdb10
brw-r----- 1 root disk 8, 27 Apr 25 22:22 /dev/sdb11
brw-r----- 1 root disk 8, 19 Apr 25 22:22 /dev/sdb3
brw-r----- 1 root disk 8, 20 Apr 25 22:22 /dev/sdb4
brw-r----- 1 root disk 8, 21 Apr 25 22:22 /dev/sdb5
brw-r----- 1 root disk 8, 22 Apr 25 22:22 /dev/sdb6
brw-r----- 1 root disk 8, 23 Apr 25 22:22 /dev/sdb7
brw-r----- 1 root disk 8, 24 Apr 25 22:22 /dev/sdb8
brw-r----- 1 root disk 8, 25 Apr 25 22:22 /dev/sdb9
root:~#

so sda is 8,0 and sdb is 8,16

and if, while discovering partitions of /dev/sda, I try to make a
partition 16 or higher, it is silently discarded by 'put_partition'.

Is that changed ?

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
