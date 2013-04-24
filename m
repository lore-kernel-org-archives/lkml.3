Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3DXTd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:33:56 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52176 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab3DXTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:33:55 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Apr 2013 12:33:33 -0700
Message-ID: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com>
Subject: WT memory type on x86_64?
To: linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For an upcoming (and, sadly, NDA'd [1]) project, I may need to use
write-through memory.  I'd like to gauge how unpleasant this will be.

AFAICT, modern CPUs allow the WT type to be set using MTRR or a PAT
entry.  Sadly, MTRRs are in short supply, and the four fully-usable
PAT slots are used for UC, UC-, WB, and WC.  I can keep my fingers
crossed and hope that there are enough free MTRRs, or I could try to
free up a PAT entry.

How nasty will the latter be?  I just looked at two rather different
modern Sandy Bridge machines, and BIOS doesn't appear to set up any
MTRRs in the WC or WP states.  As long as those MTRR types aren't
used, I think the UC- PAT entry is useless -- it behaves identically
to UC.  Lots of DRM drivers, though, seen to add a WC MTRR to cover
video memory.  Is there any need for this on modern machines?  That
is, are there any drivers that actually need the mtrr_add call to
succeed on a machine that has a working PAT?

If not, then here's a proposal:  At startup, if there are no WC or WP
MTRRs and the CPU is new enough, then set a flag for an alternative
PAT.  In alternative PAT mode, UC- is replaced with WT in the PAT and
mtrr_add fails when attempting to add a WC or WP entry.  Add
set_memory_wt, etc.  They fail in non-alternative-PAT mode.  This gets
a bit unpleasant, since _PAGE_CACHE_UC_MINUS will have a different
meaning depending on the mode.

A less conservative proposal would be to stop using UC- in the PAT
entirely.  The memtype code could learn to emulate UC- when there's an
overlapping WC or WP MTRR.

Any thoughts?  Are there known errata here?  Is there a good reason
why the kernel needs UC-?  Will this be such a big can of worms that I
should just hope there's an available MTRR?

--Andy

[1]  I hope to be able to upstream all kernel code related to this
project.  It will be neat -- I promise.  It will depend on convincing
the people on the other end of the NDA that they should let me.
