Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3JPPTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:19:09 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:65338 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3JPPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
Date: Wed, 16 Oct 2013 08:19:04 -0700
X-Google-Sender-Auth: H3M2g8O3-ESXxsI1Qle5DLk2_aw
Message-ID: <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 5:00 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
> The basic idea here is to either use a priori information on the
> intended state layout (in the case of 32-bit processes) or "sense" the
> proper layout (in the case of KVM guests) by inspecting the already
> saved FPU rip/rdp, and reading their actual values in a second save
> operation.

The rip/rdp thing looks very hacky. And *without* the rip/rdp thing, I
think the word-size always matches the TIF32 bit, right?

Why wouldn't the high bits be zero even in 64-bit mode? It would seem
to be a *major* bug if you are in 64-bit mode but (for example) try to
use the low 32-bit of virtual memory (ie something x32-like), and now
your patch decides to use the 32-bit layout.

As far as I can tell, you actually corrupt rid/rdp in that case
(because when you write the fcs thing, it overwrites the high bits of
rip, and fos overwrites the high bits of rdp). So now bits that
*should* be zero are not.

So you're basically trying to save some old state by corrupting new
state instead.

Am I overlooking something?

                Linus
