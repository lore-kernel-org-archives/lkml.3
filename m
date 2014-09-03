Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaICTGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:06:09 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34433 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbaICTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:06:04 -0400
Message-ID: <1409771156.911.23.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC] firmware coredump: add new firmware coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Date: Wed, 03 Sep 2014 21:05:56 +0200
In-Reply-To: <CAKMK7uEYKwXgDPMkA632UVX7+eN5vS6_EJqHYNnEDDg10O68zg@mail.gmail.com> (sfid-20140903_161935_874433_8AE13432)
References: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
	 <CAKMK7uEYKwXgDPMkA632UVX7+eN5vS6_EJqHYNnEDDg10O68zg@mail.gmail.com>
	 (sfid-20140903_161935_874433_8AE13432)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 16:19 +0200, Daniel Vetter wrote:
> [super-embarrassing resend, the previous one contained html gunk.]
> 
> If the idea is to also convert gpu crash dumps to this we should add
> dri-devel. And there the crashes are usually not due to firmware, but
> because the shaders and command batches userspace submitted have
> issues, so this should also be renamed to dev_coredump I think.

I don't know if the idea is to convert gpu crash dumps - I was just
wondering if you could and would want to use such a generic framework.
If the answer turns out to be no, that's perfectly reasonable I think.

However, renaming seems easy to do anyway :)

> On the overall design I wonder whether this shouldn't work more like a
> real core dump and dump to a real file. At least currently the dumps
> i915 creates are only useful as a general guide to where things went
> wrong, but if we actually want to submit them as traces to the
> hardware people we need to dump a _lot_ more. Otoh with the future of
> shared virtual address spaces between gpu/cpu we might just do a real
> core dump, so maybe this use case should be out of scope for your
> patch here.

I'm not really sure I'd want to actually sys_write() to a file here -
sounds like a big can of worms. If you have direct access (like shared
memory space) it seems we could still use the same mechanisms with the
coredumpm() method, no?

> On the logic itself I'm not sure whether the timeout is all that
> useful - at least in i915 our crash recovery works well enough that
> reporters often don't realize right away when it happened, but only
> later on when looking through logs to explain the tiny corruptions. If
> the crashdupm has evapored meanwhile that's not that useful.

Right. We might want to make it configurable, maybe even in Kconfig. I
was thinking that there would be userspace that would (automatically)
pick it up, and if such userspace doesn't exist or isn't running then
we'd want to free the memory eventually.

> Also, at least for gpus it's usually not interesting to grab
> subsequent dumps: Often the gpu is in a bad mood due to the first
> crash, or it's just a massive row of duplicated dumps. So in i915 we
> only record the first crash and keep it around forever. And tooling
> can still free it by writing to the file. This also ensures that we
> don't waste excessive amounts of memory with crash dumps.

Right, we discussed this but then I completely forgot. I think keeping
the first one is reasonable. If userspace has already picked it up
you'll still get multiple and maybe want to have a policy there as well.

> And if we want to use this for i915 we need some way for tools to go
> from the i915 drm class device node to the error state, not just from
> the error state back to the device.

Interesting. That's probably not all that difficult to do (maybe even
set up a child/parent relationship?) but I actually wanted to avoid a
hard dependency since there may be cases where the failing device
disappears, e.g. in the case of USB. I have to think about this case
more, I guess.

johannes

