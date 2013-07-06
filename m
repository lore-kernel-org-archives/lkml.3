Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3GFTyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 15:54:35 -0400
Received: from mail.nanl.de ([217.115.11.12]:41080 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3GFTyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 15:54:32 -0400
Date: Sat, 6 Jul 2013 21:54:26 +0200
From: Jonas Gorski <jogo@openwrt.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Second ethernet on kirkwood does not work when probed through DT
Message-Id: <20130706215426.6e666d6af0dc6c9ea5fe32cd@openwrt.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian,

using your DT patches[1] (on top of 3.10) I can't get the second ethernet to work on my kirkwood board.

in my dts file I use:

&mdio {
        status = "okay";
};

&eth0 {
        status = "okay";
        ethernet0-port@0 {
                speed = <1000>;
                duplex = <1>;
        };
};

&eth1 {
        status = "okay";
        ethernet1-port@1 {
                speed = <1000>;
                duplex = <1>;
        };
};

(Both macs are connected to a switch, so use a fixed link, and no phy).

Eth1 gets probed fine, but never gets a link when brought up, and trying to bring it down again hangs the board hard.

Using Florian's older patches, it is brought up fine and works (after adapting the node names of course).

Also I noticed that you named eth1's ethernet1-port node wrongly in (at least) your kirkwood conversion patch[2]; you used

&eth1 {
	status = "okay";
	ethernet1-port@0 {
           must be @1--^
		phy-handle = <&ethphy1>;
	};
};

which results in a null pointer access on boot:

...
[   12.627136] mv643xx_eth_port mv643xx_eth_port.0 eth0: port 0 with MAC address ...
[   12.635955] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   12.644100] pgd = c0004000
[   12.646821] [00000000] *pgd=00000000
[   12.650418] Internal error: Oops: 5 [#1] ARM
[   12.654702] Modules linked in:
[   12.657778] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0 #10
[   12.663634] task: c7827d60 ti: c782e000 task.ti: c782e000
[   12.669073] PC is at mv643xx_eth_probe+0x98/0x708
...


Regards
Jonas

P.S: I'm not on any ML you posted these patches to, so I could not reply directly.

[1] https://patchwork.kernel.org/patch/2632571/ etc
[2] https://patchwork.kernel.org/patch/2811861/
