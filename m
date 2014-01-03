Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaACOiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:38:09 -0500
Received: from mout2.freenet.de ([195.4.92.92]:36045 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaACOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:38:07 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2014 09:38:07 EST
Date: Fri, 3 Jan 2014 15:27:19 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: linux-kernel@vger.kernel.org
Subject: Strange problem with vxlan!
Message-ID: <20140103152719.4a8db2ce@dualc.maya.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originated-At: 79.222.19.223!53744
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given is the following network architecture: connection of a virtual bridge br0 and a remote ethernet-switch through vxlan tunnel via WLAN:



host 			[br0: tap0,vxlan0]
    				|    ||
				|    ===========
				|	      ||
				|	      ||
VM (WLAN access point)	[br0: eth0, wlan0]    ||
				      |	      ||
				      |	      ||
			  -------------	      ||
			  |		      ||
STA			[wlan0, br0: eth0, vxlan0]
				      |
				      |
   |----------------------------------|
Switch				      
   |
   ----------
	    |
notebook [eth0]



The configuration of the vxlan is:

host: route add -net 224.0.0.0 netmask 240.0.0.0 dev br0
      ip li add vxlan0 type vxlan id 1 group 239.1.1.1 dev br0

STA:  route add -net 224.0.0.0 netmask 240.0.0.0 dev wlan0
      ip li add vxlan0 type vxlan id 1 group 239.1.1.1 dev wlan0

This means: the endpoints of the vxlan tunnel are br0 (host) and STA (wlan0). 
Between them, there is the WLAN AP (a VM belonging to the host).


Now the problem:

If the VM (=AP) runs e.g. Linux 3.4.x, all is working fine as expected. 
If the VM runs 3.12.x or even 3.10.x, the tunnel works fine a few minutes after creation. Afterwards it is broken.

Broken means:
A "dhcpcd eth0" e.g. on the notebook times out, doesn't work any more. Traces show:
The udp-tunnel-packages sent by the STA through vxlan0 can be seen on the host / tap0, but they can't be seen on vxlan0 (if it works, they can be seen on the vxlan0 device, too).

On the host runs Linux 3.10.x, on the STA 3.11.6.


Any idea why vxlan is broken w/ Linux 3.12.x or 3.10.x on the VM (AP)?



Thanks in advance for any hint,
regards,
Andreas
