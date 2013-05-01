Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591Ab3EAQeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:34:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45754 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761557Ab3EAQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:34:13 -0400
Date: Wed, 1 May 2013 12:34:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andrew Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't
 already
Message-ID: <20130501163404.GA6286@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Andrew Lutomirski <luto@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501113352.GA29571@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 01:33:52PM +0200, Borislav Petkov wrote:
> It could be some fast strings erratum like AAJ6 or BD3 (they have
> different names for what apparently is the same erratum in different
> docs). Simply search for "intel fast strings erratum" and sample the
> first couple of pdfs to get an idea.

This errata does seem pretty scary:

Problem: Under certain conditions as described in the Software
	 Developers Manual section "Out-of-Order Stores For String
	 Operations in Pentium 4, Intel Xeon, and P6 Family
	 Processors" the processor performs REP MOVS or REP STOS as
	 fast strings. Due to this erratum fast string REP MOVS/REP
	 STOS instructions that cross page boundaries from WB/WC
	 memory types to UC/WP/WT memory types, may start using an
	 incorrect data size or may observe memory ordering
	 violations.

Implication: Upon crossing the page boundary the following may occur,
	     dependent on the new page memory type:

	        * UC the data size of each write will now always be 8
                  bytes, as opposed to the original data size.
		* WP the data size of each write will now always be 8
		  bytes, as opposed to the original data size and
		  there may be a memory ordering violation.
		* WT there may be a memory ordering violation.

In fact, there is the question of whether we should be checking to see
if the CPU stepping is one of the ones with the bug, and if so, to
have Linux disable fast strings even if the BIOS didn't, instead of
blindly enabling fast strings....

					- Ted
