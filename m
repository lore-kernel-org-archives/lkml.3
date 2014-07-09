Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaGIVYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:24:34 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57094 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGIVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140709191747.GB5249@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
Date: Wed, 9 Jul 2014 14:24:31 -0700
Message-ID: <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 12:17 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Jul 09, 2014 at 10:09:21AM -0700, Havard Skinnemoen wrote:
> > From: Ewout van Bekkum <ewout@google.com>
> >
> > The CMCI poll interval was updated to pick the minimum interval between
> > the original 30 seconds and the check_interval divided by 8 (minimum of
> > 3 polls).
>
> Why min 3 polls? How do you come up with exactly that frequency?

The idea is that if we make it equal to check_interval, it might
bounce back and forth a lot. So we need to divide by something, and 8
seems like a nice, safe value, and it seems to work well. We're not
opposed to considering other values, of course (e.g. 2 and 4 might
work well too, but with somewhat higher risk of ping-ponging).

> > This resolves a bug where the CMCI storm handler is unable to return to
> > interrupt mode from polling mode, if the check_interval shorter than the
> > CMCI poll interval. This problem is caused by the mce_timer_fn function
> > which only allows the poll interval to be incremented up to the
> > check_interval, while the mce_intel_adjust_timer function requires the
> > poll interval to be greater than the CMCI poll interval before leaving
> > the CMCI_STORM_ACTIVE state.
>
> Interesting. So it seems you guys want to set the check_interval to
> something < 30 secs.
>
> Out of curiosity, what is your use case which requires such small
> check_interval setting?

I'm not entirely sure. At some point, it ended up that way, and it
broke in non-obvious ways, so we wanted to fix it.

> Maybe we need to redesign and simplify this intervals thing to make it
> more user-friendly...
>
> Btw, on a related note, we're working on a small mechanism which
> collects correctable errors in the kernel and when a certain count for a
> physical error address has been reached, we soft-offline that page. We'd
> appreciate it if you guys took a look and told us whether it makes sense
> to you:
>
> http://lkml.kernel.org/r/1404242623-10094-1-git-send-email-bp@alien8.de

We will definitely take a look, thanks. Looks interesting, though it's
not always obvious what works for us until we actually go and try it.

Havard
