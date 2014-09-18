Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaIRNwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:52:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48965 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbaIRNwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:52:11 -0400
X-Sasl-enc: dpHog+qp0vp1Al4vko1nh67VRFjTkMBELnWDYjMos3ID 1411048329
Date: Thu, 18 Sep 2014 10:52:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140918135202.GA26038@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Haswell microcode update[1] removes the "hle" (hardware lock
elision) processor capability.  And it is not cosmetic, either: Intel TSX
opcodes will cause an illegal opcode trap after the microcode update[2].

This means cpu_info()->x86_capability becomes stale after the microcode
update.

We could add logic to compute the new x86_capability after a microcode
update run, and OOPS the kernel if something too important (i.e. anything
the kernel uses) went away.  Otherwise, refresh cpu_info()->x86_capability.

Is that doable?


[1] sig 0x000306f2, pf mask 0x6f, 2014-09-03, rev 0x0029, size 28672
    sig 0x000306c3, pf mask 0x32, 2014-07-03, rev 0x001c, size 21504
    sig 0x00040651, pf mask 0x72, 2014-07-03, rev 0x001c, size 20480
    sig 0x00040661, pf mask 0x32, 2014-07-03, rev 0x0012, size 23552

[2] instantly segfaulting every running process using libpthread-2.19,
    as well as any other users of Intel TSX.
    https://bugs.launchpad.net/intel/+bug/1370352

    And yes, this means we will kill support for microcode updates
    outside of the initramfs/early-initramfs, at least in Debian,
    and likely in Ubuntu.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
