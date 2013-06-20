Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab3FTF3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:29:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40149 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab3FTF3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:29:20 -0400
Date: Thu, 20 Jun 2013 07:29:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on
 defaults.
Message-ID: <20130620052911.GA32694@pd.tnic>
References: <20130618041132.GA23492@redhat.com>
 <20130618084356.GA13123@pd.tnic>
 <20130618140730.GA1313@redhat.com>
 <20130618155919.GC13123@pd.tnic>
 <51C225D9.8070100@zytor.com>
 <20130619215233.GU28300@pd.tnic>
 <51C22A6B.3090009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C22A6B.3090009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:02:19PM -0700, H. Peter Anvin wrote:
> On 06/19/2013 02:52 PM, Borislav Petkov wrote:
> > On Wed, Jun 19, 2013 at 02:42:49PM -0700, H. Peter Anvin wrote:
> >> There is serious confusion with regards to DR6 about the bits which
> >> are *fixed* (forced to 1) and the ones which are *reserved* (should
> >> always have a fixed value.)
> >>
> >> There are some bits in DR6 which are used by hardware probes.
> > 
> > Haha, I knew it! HW guys don't care about the architectural documents.
> > 
> > Maybe DR6 should probably be dropped altogether from the check before
> > exiting __show_regs early?
> 
> Uhm... I think you're missing the point of architectural documents.
> 
> The architectural documents describe the contract between hardware and
> software.  It doesn't mean that hardware can't go beyond it... it is in
> fact the norm.  The architectural documentation states what software may
> rely on and within what bounds it can assume safe behavior to be
> compatible both now and with any future extensions.

Well, that I know :).

>From your comment above it sounded like we can't really rely on some of
the bits in DR6_RESERVED to be really always 1 as they cannot only be
*fixed* (forced to 1) but also be reserved with a fixed value which is
not necessarily 1.

And there's a section in the SDM "19.23.1 Differences in Debug Register
DR6" which says that some families allow writes to 1b of bit 12 while
others don't.

Now Dave stated earlier "I occasionally see DR6: 00000000fffe0ff0 for
eg." which says that bit 16 can be 0b but the AMD spec says "read as 1s"
and Intel's spec says "Reserved (set to 1)" which I only assume is the
same thing: the default state of those is 1.

So maybe the DR6 check should be reversed to actually look at only the
defined bits and ignore "volatile" reserved bits, whichever they might
be :-):

if (!(dr6 & 0xe00f))

I.e., bit slices [15:13] and [3:0] should be 0.

Then we can assume no breakpoint condition has been detected nor the
debug registers are being used in some way.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
