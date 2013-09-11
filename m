Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3IKD4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:56:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59611 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IKD4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:56:41 -0400
Date: Wed, 11 Sep 2013 04:56:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Mace Moneta <moneta.mace@gmail.com>,
        Josh Boyer <jwboyer@gmail.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
Message-ID: <20130911035636.GI13318@ZenIV.linux.org.uk>
References: <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
 <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
 <CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
 <CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
 <CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com>
 <CAMfhy92u1GFvTrO+8SNp8hoEBEHcd7Z-3mw+79rv8+2yYqa+ow@mail.gmail.com>
 <CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com>
 <CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
 <522FCC06.3090907@hp.com>
 <CA+55aFyGEzptqWOL1P+iqqPNOomsbKzHVy1+zBQ3pE21_=KXWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyGEzptqWOL1P+iqqPNOomsbKzHVy1+zBQ3pE21_=KXWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 08:22:56PM -0700, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 6:48 PM, Waiman Long <waiman.long@hp.com> wrote:
> >
> > I need to clean up some comments in the code. The other thing that I want to
> > do is to introduce read_seqlock/read_sequnlock() primitives that do the
> > locking without incrementing the sequence number.
> 
> I don't understand. That's the whole *point* of sequence numbers. The
> read-locker doesn't ever change the number, only the write-locker
> does.
> 
> So I don't see what you would change.

I do.  What we need on the second pass (one where we currently
take seq_writelock()) is exclusion against writers; nothing we are
doing is worth disturbing the readers - we don't change any data
structures.  And simple grabbing the spinlock, without touching the
sequence number would achieve exactly that.  Writers will have to
wait and won't be able to disturb us, readers won't notice anything
happening.  So yes, this extra primitive does make sense here.
