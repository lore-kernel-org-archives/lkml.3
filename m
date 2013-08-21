Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3HUOk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:40:59 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:19117 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HUOk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:40:57 -0400
Date: Wed, 21 Aug 2013 16:41:09 +0200
From: David Jander <david.jander@protonic.nl>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821164109.6ebf943c@archvile>
In-Reply-To: <20130821140816.GC26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
	<20130821151423.70c38fb3@archvile>
	<20130821140816.GC26118@sirena.org.uk>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 15:08:16 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Aug 21, 2013 at 03:14:23PM +0200, David Jander wrote:
> 
> > Here's the explanation:
> 
> > 1. If a driver initializes a regmap with a RB-tree cache, and starts
> > writing to registers in some arbitrary order, you might get overlapping
> > rbnodes: Suppose I have this rb-tree (a real case I happen to have):
> 
> > # cat /sys/kernel/debug/regmap/1-000a/rbtree
> > 2-19 (24)
> > 4-1b (24)
> 
> Like I say this isn't supposed to be the case in the first place, those
> two nodes should be being merged - what we need to understand is where
> the overlapping nodes came from.

I have placed debug printk's all over snd_soc and regmap code to trace this
bug. Maybe you can make sense of this more than I?

Here is the complete trace with comments interspersed to explain what is going
on:

The situation is a i.MX53 based board with a SGTL5000 audio codec:

Booting the kernel, here we see the first accesses to the regmap happening:

[    1.615883] regcache_rbtree_write reg=0004 value=0008 NEW NODE ofs=0 rbnode=9fbeb940

(Here node 4-1b is created)

[    1.623786]   regcache_rbtree_set_register idx=0 value=0008 rbnode=9fbeb940
[    1.630881]   regcache_rbtree_set_register idx=2 value=0010 rbnode=9fbeb940
[    1.637897] regcache_rbtree_write reg=0006 value=0010 reg_tmp=2 rbnode=9fbeb940
[    1.645291]   regcache_rbtree_set_register idx=6 value=0010 rbnode=9fbeb940
[    1.652322] regcache_rbtree_write reg=000a value=0010 reg_tmp=6 rbnode=9fbeb940
[    1.659684]   regcache_rbtree_set_register idx=12 value=3c3c rbnode=9fbeb940
[    1.666797] regcache_rbtree_write reg=0010 value=3c3c reg_tmp=12 rbnode=9fbeb940
[    1.674281]   regcache_rbtree_set_register idx=16 value=015f rbnode=9fbeb940
[    1.681414] regcache_rbtree_write reg=0014 value=015f reg_tmp=16 rbnode=9fbeb940
[    1.688869] regcache_rbtree_write reg=0022 value=1818 NEW NODE ofs=0 rbnode=9fbeba00

Here a new node 22-39 is created.

[    1.696696]   regcache_rbtree_set_register idx=0 value=1818 rbnode=9fbeba00
[    1.703720] mmc0: host does not support reading read-only switch. assuming write-enable.
[    1.711860]   regcache_rbtree_set_register idx=2 value=0111 rbnode=9fbeba00
[    1.718840] regcache_rbtree_write reg=0024 value=0111 reg_tmp=2 rbnode=9fbeba00
[    1.726206]   regcache_rbtree_set_register idx=12 value=0404 rbnode=9fbeba00
[    1.734384] mmc0: new high speed SDHC card at address b368
[    1.740225] regcache_rbtree_write reg=002e value=0404 reg_tmp=12 rbnode=9fbeba00
[    1.747748] mmcblk0: mmc0:b368 LEXAR 7.46 GiB 
[    1.752242]   regcache_rbtree_set_register idx=14 value=7060 rbnode=9fbeba00
[    1.759309] regcache_rbtree_write reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    1.767307]   regcache_rbtree_set_register idx=16 value=5000 rbnode=9fbeba00
[    1.774538]  mmcblk0: p1 p2
[    1.777951] regcache_rbtree_write reg=0032 value=5000 reg_tmp=16 rbnode=9fbeba00
[    1.785527] regcache_rbtree_write reg=0104 value=0040 NEW NODE ofs=0 rbnode=9fbf1ec0
[    1.793343]   regcache_rbtree_set_register idx=0 value=0040 rbnode=9fbf1ec0
[    1.800327]   regcache_rbtree_set_register idx=2 value=051f rbnode=9fbf1ec0
[    1.807341] regcache_rbtree_write reg=0106 value=051f reg_tmp=2 rbnode=9fbf1ec0
[    1.814696]   regcache_rbtree_set_register idx=6 value=0040 rbnode=9fbf1ec0
[    1.821691] regcache_rbtree_write reg=010a value=0040 reg_tmp=6 rbnode=9fbf1ec0
[    1.829023]   regcache_rbtree_set_register idx=18 value=002f rbnode=9fbf1ec0
[    1.836101] regcache_rbtree_write reg=0116 value=002f reg_tmp=18 rbnode=9fbf1ec0
[    1.843532]   regcache_rbtree_set_register idx=20 value=002f rbnode=9fbf1ec0
[    1.850597] regcache_rbtree_write reg=0118 value=002f reg_tmp=20 rbnode=9fbf1ec0
[    1.858034]   regcache_rbtree_set_register idx=22 value=002f rbnode=9fbf1ec0
[    1.865114] regcache_rbtree_write reg=011a value=002f reg_tmp=22 rbnode=9fbf1ec0
[    1.872549] regcache_rbtree_write reg=011c value=002f PLACE ADJ pos=24 rbnode=9fbf1ec0
[    1.880486]  regcache_rbtree_insert_to_block reg=011c pos=24 value=002f rbnode=9fbf1ec0
[    1.888524]   regcache_rbtree_set_register idx=24 value=002f rbnode=9fbf1ec0
[    1.895608] regcache_rbtree_write reg=011e value=002f NEW NODE ofs=0 rbnode=9fbf1f40
[    1.903389]   regcache_rbtree_set_register idx=0 value=002f rbnode=9fbf1f40
[    1.910370]   regcache_rbtree_set_register idx=2 value=8000 rbnode=9fbf1f40
[    1.917362] regcache_rbtree_write reg=0120 value=8000 reg_tmp=2 rbnode=9fbf1f40
[    1.924709]   regcache_rbtree_set_register idx=6 value=0510 rbnode=9fbf1f40
[    1.931703] regcache_rbtree_write reg=0124 value=0510 reg_tmp=6 rbnode=9fbf1f40
[    1.939033]   regcache_rbtree_set_register idx=8 value=1473 rbnode=9fbf1f40
[    1.946025] regcache_rbtree_write reg=0126 value=1473 reg_tmp=8 rbnode=9fbf1f40
[    1.953369]   regcache_rbtree_set_register idx=10 value=0028 rbnode=9fbf1f40
[    1.960435] regcache_rbtree_write reg=0128 value=0028 reg_tmp=10 rbnode=9fbf1f40
[    1.967865]   regcache_rbtree_set_register idx=12 value=0050 rbnode=9fbf1f40
[    1.974945] regcache_rbtree_write reg=012a value=0050 reg_tmp=12 rbnode=9fbf1f40
[    1.983319] sgtl5000 1-000a: sgtl5000 revision 0x11
[    1.988228]   regcache_rbtree_set_register idx=0 value=0008 rbnode=9fbeb940
[    1.995232] regcache_rbtree_write reg=0004 value=0008 reg_tmp=0 rbnode=9fbeb940
[    2.003265]   regcache_rbtree_set_register idx=2 value=0010 rbnode=9fbeb940
[    2.010245] regcache_rbtree_write reg=0006 value=0010 reg_tmp=2 rbnode=9fbeb940
[    2.018271]   regcache_rbtree_set_register idx=6 value=0010 rbnode=9fbeb940
[    2.025272] regcache_rbtree_write reg=000a value=0010 reg_tmp=6 rbnode=9fbeb940
[    2.033287]   regcache_rbtree_set_register idx=12 value=3c3c rbnode=9fbeb940
[    2.040354] regcache_rbtree_write reg=0010 value=3c3c reg_tmp=12 rbnode=9fbeb940
[    2.048459]   regcache_rbtree_set_register idx=16 value=015f rbnode=9fbeb940
[    2.055543] regcache_rbtree_write reg=0014 value=015f reg_tmp=16 rbnode=9fbeb940
[    2.063649]   regcache_rbtree_set_register idx=0 value=1818 rbnode=9fbeba00
[    2.070629] regcache_rbtree_write reg=0022 value=1818 reg_tmp=0 rbnode=9fbeba00
[    2.078646]   regcache_rbtree_set_register idx=2 value=0111 rbnode=9fbeba00
[    2.085644] regcache_rbtree_write reg=0024 value=0111 reg_tmp=2 rbnode=9fbeba00
[    2.093661]   regcache_rbtree_set_register idx=12 value=0404 rbnode=9fbeba00
[    2.100728] regcache_rbtree_write reg=002e value=0404 reg_tmp=12 rbnode=9fbeba00
[    2.108833]   regcache_rbtree_set_register idx=14 value=7060 rbnode=9fbeba00
[    2.115918] regcache_rbtree_write reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    2.124022]   regcache_rbtree_set_register idx=16 value=5000 rbnode=9fbeba00
[    2.131106] regcache_rbtree_write reg=0032 value=5000 reg_tmp=16 rbnode=9fbeba00
[    2.139195]   regcache_rbtree_set_register idx=0 value=0040 rbnode=9fbf1ec0
[    2.146191] regcache_rbtree_write reg=0104 value=0040 reg_tmp=0 rbnode=9fbf1ec0
[    2.154207]   regcache_rbtree_set_register idx=2 value=051f rbnode=9fbf1ec0
[    2.161205] regcache_rbtree_write reg=0106 value=051f reg_tmp=2 rbnode=9fbf1ec0
[    2.169207]   regcache_rbtree_set_register idx=6 value=0040 rbnode=9fbf1ec0
[    2.176204] regcache_rbtree_write reg=010a value=0040 reg_tmp=6 rbnode=9fbf1ec0
[    2.184222]   regcache_rbtree_set_register idx=18 value=002f rbnode=9fbf1ec0
[    2.191306] regcache_rbtree_write reg=0116 value=002f reg_tmp=18 rbnode=9fbf1ec0
[    2.199395]   regcache_rbtree_set_register idx=20 value=002f rbnode=9fbf1ec0
[    2.206479] regcache_rbtree_write reg=0118 value=002f reg_tmp=20 rbnode=9fbf1ec0
[    2.214582]   regcache_rbtree_set_register idx=22 value=002f rbnode=9fbf1ec0
[    2.221666] regcache_rbtree_write reg=011a value=002f reg_tmp=22 rbnode=9fbf1ec0
[    2.229756]   regcache_rbtree_set_register idx=24 value=002f rbnode=9fbf1ec0
[    2.236840] regcache_rbtree_write reg=011c value=002f reg_tmp=24 rbnode=9fbf1ec0
[    2.244944]   regcache_rbtree_set_register idx=0 value=002f rbnode=9fbf1f40
[    2.251941] regcache_rbtree_write reg=011e value=002f reg_tmp=0 rbnode=9fbf1f40
[    2.259945]   regcache_rbtree_set_register idx=2 value=8000 rbnode=9fbf1f40
[    2.266942] regcache_rbtree_write reg=0120 value=8000 reg_tmp=2 rbnode=9fbf1f40
[    2.274958]   regcache_rbtree_set_register idx=6 value=0510 rbnode=9fbf1f40
[    2.281954] regcache_rbtree_write reg=0124 value=0510 reg_tmp=6 rbnode=9fbf1f40
[    2.289958]   regcache_rbtree_set_register idx=8 value=1473 rbnode=9fbf1f40
[    2.296955] regcache_rbtree_write reg=0126 value=1473 reg_tmp=8 rbnode=9fbf1f40
[    2.304971]   regcache_rbtree_set_register idx=10 value=0028 rbnode=9fbf1f40
[    2.312055] regcache_rbtree_write reg=0128 value=0028 reg_tmp=10 rbnode=9fbf1f40
[    2.320144]   regcache_rbtree_set_register idx=12 value=0050 rbnode=9fbf1f40
[    2.327228] regcache_rbtree_write reg=012a value=0050 reg_tmp=12 rbnode=9fbf1f40
[    2.337272] regcache_rbtree_read reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    2.344664] snd_soc_read(map:9fbec200): 0030 => 7060
[    2.350464]   regcache_rbtree_set_register idx=4 value=0000 rbnode=9fbeba00
[    2.357467] regcache_rbtree_write reg=0026 value=0000 reg_tmp=4 rbnode=9fbeba00
[    2.364812] snd_soc_read(map:9fbec200): 0026 => 0000
[    2.369791] snd_soc_update_bits(map:9fbec200): 0030 mask:0800 set:0000
[    2.376350] regcache_rbtree_read reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    2.383693] snd_soc_write(map:9fbec200): 0026 <= 0060
[    2.388762]   regcache_rbtree_set_register idx=4 value=0060 rbnode=9fbeba00
[    2.395755] regcache_rbtree_write reg=0026 value=0060 reg_tmp=4 rbnode=9fbeba00
[    2.403774] snd_soc_write(map:9fbec200): 0030 <= 7060
[    2.408842]   regcache_rbtree_set_register idx=14 value=7060 rbnode=9fbeba00
[    2.415926] regcache_rbtree_write reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    2.424032] snd_soc_update_bits(map:9fbec200): 0026 mask:000f set:0008
[    2.430578] regcache_rbtree_read reg=0026 value=0060 reg_tmp=4 rbnode=9fbeba00
[    2.437837]   regcache_rbtree_set_register idx=4 value=0068 rbnode=9fbeba00
[    2.444831] regcache_rbtree_write reg=0026 value=0068 reg_tmp=4 rbnode=9fbeba00
[    2.452845] snd_soc_update_bits(map:9fbec200): 0030 mask:3000 set:0000
[    2.459391] regcache_rbtree_read reg=0030 value=7060 reg_tmp=14 rbnode=9fbeba00
[    2.466738]   regcache_rbtree_set_register idx=14 value=4060 rbnode=9fbeba00
[    2.473819] regcache_rbtree_write reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[    2.481922] snd_soc_update_bits(map:9fbec200): 0028 mask:01f0 set:01f0
[    2.489281]   regcache_rbtree_set_register idx=6 value=0000 rbnode=9fbeba00
[    2.496278] regcache_rbtree_write reg=0028 value=0000 reg_tmp=6 rbnode=9fbeba00
[    2.503623]   regcache_rbtree_set_register idx=6 value=01f0 rbnode=9fbeba00
[    2.510601] regcache_rbtree_write reg=0028 value=01f0 reg_tmp=6 rbnode=9fbeba00
[    2.518616] snd_soc_update_bits(map:9fbec200): 002c mask:0f3f set:0322
[    2.525992]   regcache_rbtree_set_register idx=10 value=0000 rbnode=9fbeba00
[    2.533076] regcache_rbtree_write reg=002c value=0000 reg_tmp=10 rbnode=9fbeba00
[    2.540493]   regcache_rbtree_set_register idx=10 value=0322 rbnode=9fbeba00
[    2.547574] regcache_rbtree_write reg=002c value=0322 reg_tmp=10 rbnode=9fbeba00
[    2.555674] snd_soc_update_bits(map:9fbec200): 0028 mask:0001 set:0001
[    2.562237] regcache_rbtree_read reg=0028 value=01f0 reg_tmp=6 rbnode=9fbeba00
[    2.569480]   regcache_rbtree_set_register idx=6 value=01f1 rbnode=9fbeba00
[    2.576473] regcache_rbtree_write reg=0028 value=01f1 reg_tmp=6 rbnode=9fbeba00
[    2.584487] snd_soc_write(map:9fbec200): 003c <= 0000
[    2.589567] regcache_rbtree_write reg=003c value=0000 NEW NODE ofs=0 rbnode=9fbeffc0
[    2.597349]   regcache_rbtree_set_register idx=0 value=0000 rbnode=9fbeffc0
[    2.605015] snd_soc_write(map:9fbec200): 000a <= 0010
[    2.610083]   regcache_rbtree_set_register idx=6 value=0010 rbnode=9fbeb940
[    2.617081] regcache_rbtree_write reg=000a value=0010 reg_tmp=6 rbnode=9fbeb940
[    2.625095] snd_soc_write(map:9fbec200): 0002 <= 0060
[    2.630169] regcache_rbtree_write reg=0002 value=0060 NEW NODE ofs=0 rbnode=9fbf3040

(... and here node 2-19 is created)

[    2.637949]   regcache_rbtree_set_register idx=0 value=0060 rbnode=9fbf3040
[    2.645614] snd_soc_write(map:9fbec200): 000e <= 020c
[    2.651357] snd_soc_write(map:9fbec200): 0014 <= 015f
[    2.656426]   regcache_rbtree_set_register idx=18 value=015f rbnode=9fbf3040

This is access to register 0014 (hex) which is index 18 (dec) of this new
node. You can see that rbnode points to 9fbf3040, which is the node we just
created (2-19). This should have hit 4-1b though!

[    2.663509] regcache_rbtree_write reg=0014 value=015f reg_tmp=18 rbnode=9fbf3040
[    2.671610] snd_soc_write(map:9fbec200): 0024 <= 0022
[    2.676678]   regcache_rbtree_set_register idx=2 value=0022 rbnode=9fbeba00
[    2.683673] regcache_rbtree_write reg=0024 value=0022 reg_tmp=2 rbnode=9fbeba00
[    2.691687] snd_soc_write(map:9fbec200): 002a <= 0002
[    2.696755]   regcache_rbtree_set_register idx=8 value=0002 rbnode=9fbeba00
[    2.703749] regcache_rbtree_write reg=002a value=0002 reg_tmp=8 rbnode=9fbeba00
[    2.711764] snd_soc_write(map:9fbec200): 0100 <= 0000
[    2.716838] regcache_rbtree_write reg=0100 value=0000 NEW NODE ofs=0 rbnode=9fbf30c0
[    2.724617]   regcache_rbtree_set_register idx=0 value=0000 rbnode=9fbf30c0
[    2.732342] regcache_rbtree_read reg=0024 value=0022 reg_tmp=2 rbnode=9fbeba00
[    2.739587] snd_soc_read(map:9fbec200): 0024 => 0022
[    2.744593] regcache_rbtree_read reg=0024 value=0022 reg_tmp=2 rbnode=9fbeba00
[    2.751852] snd_soc_read(map:9fbec200): 0024 => 0022
[    2.756838] regcache_rbtree_read reg=0024 value=0022 reg_tmp=2 rbnode=9fbeba00
[    2.764094] snd_soc_read(map:9fbec200): 0024 => 0022
[    2.769078] regcache_rbtree_read reg=0024 value=0022 reg_tmp=2 rbnode=9fbeba00
[    2.776334] snd_soc_read(map:9fbec200): 0024 => 0022
[    2.781402] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[    2.788735] snd_soc_read(map:9fbec200): 0030 => 4060
[    2.793743] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[    2.801099] snd_soc_read(map:9fbec200): 0030 => 4060
[    2.806100] regcache_rbtree_read reg=0002 value=0060 reg_tmp=0 rbnode=9fbf3040
[    2.813361] snd_soc_read(map:9fbec200): 0002 => 0060
[    2.818349] regcache_rbtree_read reg=0002 value=0060 reg_tmp=0 rbnode=9fbf3040
[    2.825608] snd_soc_read(map:9fbec200): 0002 => 0060
[    2.830627] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[    2.837976] snd_soc_read(map:9fbec200): 0030 => 4060
[    2.842980] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[    2.850310] snd_soc_read(map:9fbec200): 0030 => 4060
[    2.855313] regcache_rbtree_read reg=002a value=0002 reg_tmp=8 rbnode=9fbeba00
[    2.862571] snd_soc_read(map:9fbec200): 002a => 0002
[    2.868368] imx-sgtl5000 sound.7:  sgtl5000 <-> 50014000.ssi mapping ok
[    2.875181] snd_soc_write(map:9fbec200): 0006 <= 0080
[    2.880259]   regcache_rbtree_set_register idx=2 value=0080 rbnode=9fbeb940
[    2.887263] regcache_rbtree_write reg=0006 value=0080 reg_tmp=2 rbnode=9fbeb940
[    2.896319] TCP: cubic registered
[    2.900148] NET: Registered protocol family 10
[    2.905487] sit: IPv6 over IPv4 tunneling driver
[    2.910709] NET: Registered protocol family 17
[    2.915252] can: controller area network core (rev 20120528 abi 9)
[    2.921554] NET: Registered protocol family 29
[    2.926059] can: raw protocol (rev 20120528)
[    2.930342] can: broadcast manager protocol (rev 20120528 t)
[    2.936045] can: netlink gateway (rev 20130117) max_hops=1
[    2.941789] Key type dns_resolver registered
[    2.946186] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 2
[    2.955837] ci_hdrc ci_hdrc.0: doesn't support gadget
[    2.961021] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    2.965943] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[    2.990837] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[    2.996930] hub 1-0:1.0: USB hub found
[    3.000723] hub 1-0:1.0: 1 port detected
[    3.005310] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    3.022184] Console: switching to colour frame buffer device 128x48
[    3.034088] imx-drm imx-drm: fb0:  frame buffer device
[    3.039304] imx-drm imx-drm: registered panic notifier
[    3.051117] ALSA device list:
[    3.054188]   #0: lelelm-sgtl5000
[    3.059291] EXT3-fs (mmcblk0p2): error: couldn't mount because of unsupported optional features (240)
[    3.069639] EXT2-fs (mmcblk0p2): error: couldn't mount because of unsupported optional features (244)
[    5.229061] EXT4-fs (mmcblk0p2): recovery complete
[    5.236671] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    5.245021] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    5.253245] devtmpfs: mounted
[    5.256630] Freeing unused kernel memory: 208K (8066c000 - 806a0000)
[    5.699759] init: ureadahead main process (60) terminated with status 5
[    5.868875] init: mounted-proc main process (67) terminated with status 1
[    7.575359] udevd[158]: starting version 175
[    9.384951] init: plymouth main process (61) killed by ABRT signal
[    9.453319] init: plymouth-splash main process (248) terminated with status 2
[    9.660629] snd_soc_write(map:9fbec200): 0010 <= 6c6c
[    9.660671]   regcache_rbtree_set_register idx=12 value=6c6c rbnode=9fbeb940
[    9.660684] regcache_rbtree_write reg=0010 value=6c6c reg_tmp=12 rbnode=9fbeb940
[    9.685406] snd_soc_update_bits(map:9fbec200): 0020 mask:00ff set:00cc
[    9.687910] regcache_rbtree_write reg=0020 value=0000 NEW NODE ofs=0 rbnode=9f3ffcc0

Here a new node 20-37 is created, while a node 22-39 already existed. This is
now the rbtree_ctx->cached_rbnode.

[    9.687929]   regcache_rbtree_set_register idx=0 value=0000 rbnode=9f3ffcc0
[    9.687945]   regcache_rbtree_set_register idx=0 value=00cc rbnode=9f3ffcc0
[    9.687955] regcache_rbtree_write reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[    9.690108] snd_soc_update_bits(map:9fbec200): 0020 mask:0100 set:0000
[    9.690134] regcache_rbtree_read reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[    9.690170] snd_soc_update_bits(map:9fbec200): 0024 mask:0002 set:0002

That's why all the following accesses hit the wrong node (cached):

[    9.690180] regcache_rbtree_read reg=0024 value=0000 reg_tmp=4 rbnode=9f3ffcc0
[    9.690193]   regcache_rbtree_set_register idx=4 value=0002 rbnode=9f3ffcc0
[    9.690203] regcache_rbtree_write reg=0024 value=0002 reg_tmp=4 rbnode=9f3ffcc0
[    9.696096] snd_soc_update_bits(map:9fbec200): 0022 mask:7f7f set:4040
[    9.696127] regcache_rbtree_read reg=0022 value=0000 reg_tmp=2 rbnode=9f3ffcc0
[    9.696143]   regcache_rbtree_set_register idx=2 value=4040 rbnode=9f3ffcc0
[    9.696155] regcache_rbtree_write reg=0022 value=4040 reg_tmp=2 rbnode=9f3ffcc0
[    9.696965] snd_soc_update_bits(map:9fbec200): 0024 mask:0020 set:0020
[    9.696983] regcache_rbtree_read reg=0024 value=0002 reg_tmp=4 rbnode=9f3ffcc0
[    9.696994]   regcache_rbtree_set_register idx=4 value=0022 rbnode=9f3ffcc0
[    9.697004] regcache_rbtree_write reg=0024 value=0022 reg_tmp=4 rbnode=9f3ffcc0
[    9.700468] snd_soc_update_bits(map:9fbec200): 002a mask:0003 set:0003
[    9.700498] regcache_rbtree_read reg=002a value=fc33 reg_tmp=10 rbnode=9f3ffcc0
[    9.700554] regcache_rbtree_read reg=0024 value=0022 reg_tmp=4 rbnode=9f3ffcc0
[    9.700564] snd_soc_read(map:9fbec200): 0024 => 0022
[    9.700713] regcache_rbtree_read reg=0024 value=0022 reg_tmp=4 rbnode=9f3ffcc0
[    9.700731]   regcache_rbtree_set_register idx=4 value=0062 rbnode=9f3ffcc0
[    9.700743] regcache_rbtree_write reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[    9.708348] regcache_rbtree_read reg=0030 value=1ce9 reg_tmp=16 rbnode=9f3ffcc0
[    9.708378]   regcache_rbtree_set_register idx=16 value=1cf9 rbnode=9f3ffcc0
[    9.708390] regcache_rbtree_write reg=0030 value=1cf9 reg_tmp=16 rbnode=9f3ffcc0
[    9.709319] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[    9.709337] snd_soc_read(map:9fbec200): 0024 => 0062
[   11.470054] snd_soc_write(map:9fbec200): 0010 <= 6c6c
[   11.470096]   regcache_rbtree_set_register idx=12 value=6c6c rbnode=9fbeb940
[   11.470110] regcache_rbtree_write reg=0010 value=6c6c reg_tmp=12 rbnode=9fbeb940
[   11.493136] snd_soc_update_bits(map:9fbec200): 0020 mask:00ff set:00cc
[   11.493168] regcache_rbtree_read reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[   11.493212] snd_soc_update_bits(map:9fbec200): 0020 mask:0100 set:0000
[   11.493224] regcache_rbtree_read reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[   11.493255] snd_soc_update_bits(map:9fbec200): 0024 mask:0002 set:0002
[   11.493266] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[   11.493417] snd_soc_update_bits(map:9fbec200): 0022 mask:7f7f set:4040
[   11.493430] regcache_rbtree_read reg=0022 value=4040 reg_tmp=2 rbnode=9f3ffcc0
[   11.493465] snd_soc_update_bits(map:9fbec200): 0024 mask:0020 set:0020
[   11.493475] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[   11.493553] snd_soc_update_bits(map:9fbec200): 002a mask:0003 set:0003
[   11.493564] regcache_rbtree_read reg=002a value=fc33 reg_tmp=10 rbnode=9f3ffcc0
[   11.493609] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[   11.493619] snd_soc_read(map:9fbec200): 0024 => 0062
[   11.493652] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[   11.493661] snd_soc_read(map:9fbec200): 0024 => 0062
[   11.743662] init: plymouth-stop pre-start process (414) terminated with status 1

At second number 131 I started mplayer to play an MP3 file. At that moment the
SGTL5000 codec crashed, it's internal PLL ran away and the I2C bus hang with
SDA permanently low. Game over!

[  131.495632] snd_soc_write(map:9fbec200): 0010 <= 6c6c
[  131.495673]   regcache_rbtree_set_register idx=12 value=6c6c rbnode=9fbeb940
[  131.495687] regcache_rbtree_write reg=0010 value=6c6c reg_tmp=12 rbnode=9fbeb940
[  131.518202] snd_soc_update_bits(map:9fbec200): 0020 mask:00ff set:00cc
[  131.518236] regcache_rbtree_read reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[  131.518279] snd_soc_update_bits(map:9fbec200): 0020 mask:0100 set:0000
[  131.518289] regcache_rbtree_read reg=0020 value=00cc reg_tmp=0 rbnode=9f3ffcc0
[  131.518320] snd_soc_update_bits(map:9fbec200): 0024 mask:0002 set:0002
[  131.518330] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[  131.518485] snd_soc_update_bits(map:9fbec200): 0022 mask:7f7f set:4040
[  131.518497] regcache_rbtree_read reg=0022 value=4040 reg_tmp=2 rbnode=9f3ffcc0
[  131.518533] snd_soc_update_bits(map:9fbec200): 0024 mask:0020 set:0020
[  131.518544] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[  131.518625] snd_soc_update_bits(map:9fbec200): 002a mask:0003 set:0003
[  131.518638] regcache_rbtree_read reg=002a value=fc33 reg_tmp=10 rbnode=9f3ffcc0
[  131.518683] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[  131.518694] snd_soc_read(map:9fbec200): 0024 => 0062
[  131.518727] regcache_rbtree_read reg=0024 value=0062 reg_tmp=4 rbnode=9f3ffcc0
[  131.518737] snd_soc_read(map:9fbec200): 0024 => 0062
[  131.672727] init: plymouth-stop pre-start process (482) terminated with status 1

Now I started hitting CTRL-C to stop mplayer, closeing the audio device:

[  296.256133] snd_soc_update_bits(map:9fbec200): 0030 mask:4000 set:4000
[  296.256168] regcache_rbtree_read reg=0030 value=1cf9 reg_tmp=16 rbnode=9f3ffcc0
[  296.256185]   regcache_rbtree_set_register idx=16 value=5cf9 rbnode=9f3ffcc0
[  296.256196] regcache_rbtree_write reg=0030 value=5cf9 reg_tmp=16 rbnode=9f3ffcc0
[  296.256914] sgtl5000_set_clock sys_fs = 44100
[  296.256928] sgtl5000_set_clock out==17 t==5776462
[  296.256935] sgtl5000_set_clock int_div==17 frac_div==1150
[  296.256944] snd_soc_write(map:9fbec200): 0032 <= 8c7e
[  296.256957]   regcache_rbtree_set_register idx=18 value=8c7e rbnode=9f3ffcc0
[  296.256966] regcache_rbtree_write reg=0032 value=8c7e reg_tmp=18 rbnode=9f3ffcc0
[  296.257634] snd_soc_update_bits(map:9fbec200): 0034 mask:0008 set:0000
[  296.258444]   regcache_rbtree_set_register idx=20 value=0000 rbnode=9f3ffcc0
[  296.258455] regcache_rbtree_write reg=0034 value=0000 reg_tmp=20 rbnode=9f3ffcc0
[  296.258464] snd_soc_update_bits(map:9fbec200): 0030 mask:0500 set:0500
[  296.258474] regcache_rbtree_read reg=0030 value=5cf9 reg_tmp=16 rbnode=9f3ffcc0
[  296.258483]   regcache_rbtree_set_register idx=16 value=5df9 rbnode=9f3ffcc0
[  296.258492] regcache_rbtree_write reg=0030 value=5df9 reg_tmp=16 rbnode=9f3ffcc0
[  296.259161] regcache_rbtree_read reg=0030 value=5df9 reg_tmp=16 rbnode=9f3ffcc0
[  296.259172] snd_soc_read(map:9fbec200): 0030 => 5df9
[  296.259180] snd_soc_write(map:9fbec200): 0004 <= 0007
[  296.259190]   regcache_rbtree_set_register idx=0 value=0007 rbnode=9fbeb940
[  296.259199] regcache_rbtree_write reg=0004 value=0007 reg_tmp=0 rbnode=9fbeb940
[  296.259866] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[  296.259877] snd_soc_read(map:9fbec200): 0030 => 4060
[  296.259887] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[  296.259895] snd_soc_read(map:9fbec200): 0030 => 4060
[  296.259903] snd_soc_update_bits(map:9fbec200): 0006 mask:0130 set:0010
[  296.259912] regcache_rbtree_read reg=0006 value=0080 reg_tmp=2 rbnode=9fbeb940
[  296.259922]   regcache_rbtree_set_register idx=2 value=0090 rbnode=9fbeb940
[  296.259931] regcache_rbtree_write reg=0006 value=0090 reg_tmp=2 rbnode=9fbeb940
[  296.260598] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[  296.260607] snd_soc_read(map:9fbec200): 0030 => 4060
[  296.271186] regcache_rbtree_read reg=0002 value=0060 reg_tmp=0 rbnode=9fbf3040
[  296.271216]   regcache_rbtree_set_register idx=0 value=0061 rbnode=9fbf3040
[  296.271228] regcache_rbtree_write reg=0002 value=0061 reg_tmp=0 rbnode=9fbf3040
[  296.271952] regcache_rbtree_read reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[  296.271968]   regcache_rbtree_set_register idx=14 value=4068 rbnode=9fbeba00
[  296.271977] regcache_rbtree_write reg=0030 value=4068 reg_tmp=14 rbnode=9fbeba00
[  296.780835] regcache_rbtree_read reg=0030 value=4068 reg_tmp=14 rbnode=9fbeba00
[  296.780860]   regcache_rbtree_set_register idx=14 value=4069 rbnode=9fbeba00
[  296.780871] regcache_rbtree_write reg=0030 value=4069 reg_tmp=14 rbnode=9fbeba00
[  297.290811] snd_soc_update_bits(map:9fbec200): 0030 mask:0080 set:0080
[  297.290829] regcache_rbtree_read reg=0030 value=4069 reg_tmp=14 rbnode=9fbeba00
[  297.290843]   regcache_rbtree_set_register idx=14 value=40e9 rbnode=9fbeba00
[  297.290853] regcache_rbtree_write reg=0030 value=40e9 reg_tmp=14 rbnode=9fbeba00
[  297.800855] snd_soc_update_bits(map:9fbec200): 000e mask:000c set:0000
[  299.678282] snd_soc_update_bits(map:9fbec200): 000e mask:000c set:000c
[  305.190930] regcache_rbtree_read reg=0030 value=40e9 reg_tmp=14 rbnode=9fbeba00
[  305.190950] snd_soc_read(map:9fbec200): 0030 => 40e9
[  305.190959] snd_soc_update_bits(map:9fbec200): 0030 mask:0080 set:0000
[  305.190970] regcache_rbtree_read reg=0030 value=40e9 reg_tmp=14 rbnode=9fbeba00
[  305.190987]   regcache_rbtree_set_register idx=14 value=4069 rbnode=9fbeba00
[  305.190998] regcache_rbtree_write reg=0030 value=4069 reg_tmp=14 rbnode=9fbeba00
[  306.110828] regcache_rbtree_read reg=0030 value=4069 reg_tmp=14 rbnode=9fbeba00
[  306.110849]   regcache_rbtree_set_register idx=14 value=4068 rbnode=9fbeba00
[  306.110860] regcache_rbtree_write reg=0030 value=4068 reg_tmp=14 rbnode=9fbeba00
[  306.620813] regcache_rbtree_read reg=0030 value=4068 reg_tmp=14 rbnode=9fbeba00
[  306.620831]   regcache_rbtree_set_register idx=14 value=4060 rbnode=9fbeba00
[  306.620841] regcache_rbtree_write reg=0030 value=4060 reg_tmp=14 rbnode=9fbeba00
[  307.130812] regcache_rbtree_read reg=0002 value=0061 reg_tmp=0 rbnode=9fbf3040
[  307.130830]   regcache_rbtree_set_register idx=0 value=0060 rbnode=9fbf3040
[  307.130839] regcache_rbtree_write reg=0002 value=0060 reg_tmp=0 rbnode=9fbf3040

Best regards,

-- 
David Jander
Protonic Holland.
