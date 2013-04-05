Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162557Ab3DETQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:16:50 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48416 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162523Ab3DETQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <201304052008.15412.chunkeey@googlemail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<201304051903.11215.chunkeey@googlemail.com>
	<CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
	<201304052008.15412.chunkeey@googlemail.com>
Date: Fri, 5 Apr 2013 12:16:46 -0700
X-Google-Sender-Auth: raYPjN6mNCLUq0lZqysdBZ-H8H8
Message-ID: <CAJ-VmomdD9nOrAb0_cY7vYw1DiP7ENnGALW=24newMj-XZ4cTA@mail.gmail.com>
Subject: Re: Version number policy!
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The point here is that once we hit a new major version, all the
previous version checks can go away.

So, if we decide to change some WMI message formats, it'll be in 2.x
rather than 1.x.

For example, has talked about killing off rate control in the NIC and
doing it on the host. I'm happy with that (since it's easy enough to
move back into the NIC if people want it for whatever reason) so:

* Do we make it configurable?
* Do we make it backwards compatible?
* Do we just say "oh screw this" and treat it as part of the next
major revision?

If I were doing this for work and there was a long lifetime
requirement for this stuff, then sure, we may have pressure from
various groups to maintain backwards compatibility. And as we do so,
we end up slowly bloating out the firmware and adding more driver
capabilities.

But since we're doing this in an open community, we can just create
branches and let people who wish to maintain things do so, whilst not
tying ourselves down too much. We have very specific pressures here
(ie, how much RAM and CPU these little USB SoCs have), so we can't
just infinitely grow the API.

If there are bugfixes that someone like Google, Redhat or Canonical
need for the 1.3 firmware in say, 2015 (when we've moved onto a much
later evolution of this firmware) because they have a compat-wireless
download that _only gets bugfixes_ and doesn't get new features (ie
,doesn't just sync against the latest compat-wireless to get bugfixes
_and_ features), then they're quite welcome to cherry-pick fixes from
mainline, merge them into the 1.3 branch and send a diff or pull
request. But I personally don't want to maintain config options and
backwards compatibility outside of what goes on in a minor branch.

So, to address Christian's concern in more specific detail:

* I intend that major revisions are break points, and that when we
push out a new major revision, ath9k_htc (or whatever it becomes) will
eventually update to use that;
* .. then we can do things that break backwards compatibility, which
means we can kill all those capability checks if we need to;
* For things that occur during a given major release branch, we can
either use a capability bitmap OR we can do it via versioning -
because I don't want to see ath9k_htc try to support >1 major version;
* How we do that check isn't really that big a deal - as long as the
checks look like:

if (feature_xxx(sc)) {
}

.. we can easily just change feature_xxx() to be a bitmap check or a
version check.

* And then once we push out a new major release, we can reap features
that are either on by default in the new major release.

How's that sound?


Adrian
