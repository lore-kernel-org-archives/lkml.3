Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaB1Ccz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:32:55 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42843 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaB1Ccy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:32:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140227113748.GY9383@sirena.org.uk>
References: <1393473057-19919-1-git-send-email-abrestic@chromium.org>
	<20140227113748.GY9383@sirena.org.uk>
Date: Thu, 27 Feb 2014 18:32:53 -0800
X-Google-Sender-Auth: E-frLuX65ppHmMfEslGUrT0IzIU
Message-ID: <CAL1qeaF2RtC--K06qWkMRjBAOzoVfxi845RwZX05QwXS66Ns9Q@mail.gmail.com>
Subject: Re: [PATCH] regmap: don't use spinlocks with REGCACHE_{RBTREE,COMPRESSED}
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 3:37 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Feb 26, 2014 at 07:50:57PM -0800, Andrew Bresticker wrote:
>> Both REGCACHE_RBTREE and REGCACHE_COMPRESSED make GFP_KERNEL allocations
>> with the regmap lock held.  If we're initializing a regmap which would
>> normally use a spinlock (e.g. MMIO), fall back to using a mutex if one
>> of these caching types is to be used.
>
> Have all the users been audited to verify that they're actually safe
> with this?  I just took a quick look at the Tegra drivers and they're
> doing regmap operations in their trigger operations which is done from
> atomic context so they should run into problems trying to take mutexes
> anyway.

Oops, you're right, I didn't look through all the regmap operations
carefully enough.  It is in fact the Tegra drivers I've ran into this
issue with.

> I think we need to either ensure that all users allocate their caches at
> probe time (which is fine and is hopefully what the current users are
> doing), provide a mechanism for them to do cache allocations outside of
> the spinlock (which sounds hairy) or convert them to flat cache.

Allocations are made in the write path for rbtree and in both the read
and write paths for lzo.  I suppose we can pre-allocate everything at
init time, but I haven't looked too much at that.  For at least the
Tegra drivers, the best option for now appears to be to convert to a
flat cache.

Thanks,
Andrew
