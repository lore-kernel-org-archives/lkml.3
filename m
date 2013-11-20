Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3KTRM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:12:27 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60362 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3KTRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:12:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131120155507.GA5380@fieldses.org>
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag> <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
 <20131120153703.GA23160@thunk.org> <20131120155507.GA5380@fieldses.org>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 20 Nov 2013 22:41:54 +0530
Message-ID: <CAK-9PRCQ6qWvzpdvK8BswpS+TfgM7NeoRaVdChFHhyDjwtUGTw@mail.gmail.com>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 9:25 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> Some SSD's are also claim the ability to flush the cache on power loss:
>
>         http://www.intel.com/content/www/us/en/solid-state-drives/ssd-320-series-power-loss-data-protection-brief.html
>
> Which should in theory let them respond immediately to flush requests,
> right?  Except they only seem to advertise it as a safety (rather than a
> performance) feature, so I probably misunderstand something.
>
> And the 520 doesn't claim this feature (look for "enhanced power loss
> protection" at http://ark.intel.com/products/66248), so that wouldn't
> explain these results anyway.

FYI, nowhere does Intel imply that the CMD_FLUSH is instantaneous. The
product brief for Intel 320 SSDs (above link), explains that it is
implemented by a power-fail detection circuit that detects drop in
power-supply, following which the on-disk controller issues an internal
CMD_FLUSH equivalent command to ensure data is moved to the
non-volatile area from the disk-cache. Large secondary capacitors
ensure backup supply for this brief duration.

Thus applications can always perform asynchronous I/O upon the disk,
taking comfort in the fact that the physical disk ensures that all
data in the volatile disk-cache is automatically transferred to the
non-volatile area even in the event of an external power-failure. Thus
the host never has to worry about issuing a CMD_FLUSH (which is still
a terribly expensive performance bottleneck, even on the Intel 320
SSDs).
