Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDAV3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:29:43 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61698 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaDAV3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:29:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140331212522.GB8979@xanatos>
References: <1395772963-14127-1-git-send-email-jwerner@chromium.org>
	<20140331212522.GB8979@xanatos>
Date: Tue, 1 Apr 2014 14:29:40 -0700
X-Google-Sender-Auth: Uy3yUwJNVqaiwgCiHQ5o9cD2IYE
Message-ID: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://marc.info/?l=linux-usb&m=137158978503741&w=2
>
> There's an xHCI spec ambiguity:  Does the last valid context entry refer
> to the last valid endpoint context in the *input* device context or the
> *output* device context?
>
> The code currently assumes it refers to the input device context, namely
> the endpoints we're adding or changing.  If hardware needs the last
> valid endpoint context for the re-calculated *output* device context,
> then yes, this needs to be changed.  However, based on spec errata, I
> believe that's not the intent of the spec authors:
>
> http://marc.info/?l=linux-kernel&m=137208958411696&w=2

Oh, okay, it didn't even occur to me to interpret it that way. It
seems very odd since then Context Entries is essentially redundant
with the information already provided by the Add Context flags.

> What is the impact if we calculate the valid last valid endpoint context
> for the input context?  Do you have evidence of hardware misbehaving?
> If so, which hardware?

I haven't actually seen a problem from this, it just seemed like the
right thing to do for me when looking at it. The only real error we
had was when the command fails due to Context Entries being 0.

However, the question remains: What is the right value for Context
Entries when we have no Add Context flags, or only the SLOT_FLAG? It
should be perfectly legal to just drop a bunch of endpoints without
adding/changing anything else, such as when you switch a UVC interface
back to alternate setting 0 (which has no endpoints). Then the Input
Context really ends at the Slot Context (DCI = 0), but Context Entries
= 0 is very clearly forbidden in the spec. I guess we could just force
it to 1 there and it would probably work, but that would technically
be incorrect since the EP0 context is not updated and not part of the
Add Context flags.
