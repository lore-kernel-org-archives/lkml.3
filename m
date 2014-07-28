Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaG1Ugx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:36:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47993 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbaG1Ugu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:36:50 -0400
X-Sasl-enc: yJP9GyRk/jCm5OA1KBEBa6Q83ceLqbMlM0KXtUEiTXgf 1406579809
Date: Mon, 28 Jul 2014 17:36:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 8/8] x86, microcode, intel: correct extended signature
 checksum verification
Message-ID: <20140728203638.GA20113@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-9-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406146251-8540-9-git-send-email-hmh@hmh.eng.br>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Henrique de Moraes Holschuh wrote:
> We have been calculating the checksum for extended signatures in a way that
> is very likely to be incompatible with the Intel public documention.  This
> code dates back to 2003, when the support for the "new microcode format"
> was added to the driver by Intel itself.
> 
> The extended signature table should be deleted when an extended signature
> is "applied" to the main microcode patch if the Intel SDM is to be believed
> (Intel 64 and IA32 Software Developers Manual, vol 3A, page 9-30, entry for
> "Checksum[n]" in table 9-6).  Deleting the extended signature table changes
> the Total Size of the microcode, and that reflects in the checksum that
> should be in the extended signature entry if it is to be used unmodified to
> replace the main microcode signature.
> 
> It is worth noting that deleting the extended signature table results in a
> microcode patch that violates the rule that the Total Size field must be a
> multiple of 1024, and it is impossible to add any padding to fix that.
> 
> This patch changes the extended signature table checksum verification
> code to accept both ways of calculating the extended signature checksum
> as valid.

It looks like this might not be enough.

TianoCore USDK2014 (UEFI reference code) and OpenSolaris do it in a
completely different, and utterly incompatible way.  For the record, they
sum all three dwords on the extended signature entry (including the checksum
one) and expect it to be zero.   How the heck did they went from what is
described in the Intel SDM to that crazy code, I have no idea.

At this point, I do think we could just remove the entire extended signature
support, and be happy with the LOC reduction.  That's code that has never
seen use in 11 years, and which nobody seems to agree on how it should be
implemented.  I very much doubt it will ever be used at this point.

Anyway, I propose we stop checking the checksum on the extended microcode
signature entirely.  They are already covered by the checksum of the
extended microcode signature *table* (which covers all extended signature
entries).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
