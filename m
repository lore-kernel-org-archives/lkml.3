Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaAYQgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 11:36:05 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40343 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbaAYQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 11:36:03 -0500
X-Sasl-enc: fNXipq5KNIaoLF86xAgZxbBk1vHb7EEfB8XFZJAQ43rl 1390667762
Date: Sat, 25 Jan 2014 14:35:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] x86, microcode: Add option to allow downgrading of
 microcode
Message-ID: <20140125163558.GC25531@khazad-dum.debian.net>
References: <1390598339-18740-1-git-send-email-andi@firstfloor.org>
 <1390598339-18740-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390598339-18740-2-git-send-email-andi@firstfloor.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Andi Kleen wrote:
> For testing purposes it can be useful to downgrade microcode.
> Normally the driver only allows upgrading.

The code is not prepared to work correctly when downgrading is allowed, in
the presence of shadowed microcode.  When a firmware request results in more
than one microcode for the same cpuid, with overlapping pf_mask, the code
*depends* on the "never downgrade" logic to work.

Shadowed microcode *is* currently distributed by Intel, and as an artifact
of the f-m-s grouping, it is *guaranteed* to trigger the issue.  When the
issue triggers, what microcode will be selected to be uploaded to the core
depends *only* on the order of the microcodes in the firmware file.

I see no documentation of this fact anywhere, and it is *anything* but
obvious.

That extremely obnoxious Intel microcode license forbids anyone to fix the
pf_mask metadata fields to remove shadowing, so we ship that stuff as-is to
in the distros.  It *will* hit users.

Also, since you're going to mess with this, why don't you implement the
correct semanthics for microcode with the sign bit set?  Making it signed
actually makes the current code behaviour worse.

Refer to: http://lkml.org/lkml/2011/3/21/522

Note that I was wrong about negative revision microcode not being found in
the wild.  Intel has shipped entry-level server boards with pre-release
microcode several times, even on BIOS updates, and you're likely to get
access to such pre-release microcode if you're dealing with Intel firmware
partners that has full access to microcode updates.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
