Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaFYIZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:25:11 -0400
Received: from mout.gmx.net ([212.227.17.21]:56260 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaFYIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <1403677528.7903.103.camel@sauron.fi.intel.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	<alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	<1403677528.7903.103.camel@sauron.fi.intel.com>
Date: Wed, 25 Jun 2014 10:25:05 +0200
Message-ID: <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Thomas Knauth <thomas.knauth@gmx.de>
To: dedekind1@gmail.com
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Provags-ID: V03:K0:g8AEo4WxDsEXY7wx3BUvWRFixEQVBQgA8RQ5Hw+dc7OgnpAM5QK
 krkKCYVk1f4vQRqmb3RjV+UXA/YIRuj9F33OV9bwKtkCtDqLPn48v0q1cu0335FrlFcaGsK
 CWtPLoVDL4jxr9pN989lFO4Dl7rPO5k9FqLoLZQyR37z6rnXToiIaJujxN/SwkCRbBnuAdB
 mL5XesOForm/MWZ1riecQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> Plus some explanations WRT why proc-based interface and what would be
> the alternatives, what if tomorrow we want to extend the functionality
> and drop caches only for certain file range, is this only for regular
> files or also for directories, why posix_fadvice(DONTNEED) is not
> sufficient.

I suggested the idea originally. Let me address each of your questions in turn:

Why a selective drop? To have a middle ground between echo 2 >
drop_caches and echo 3 > drop_caches. When is this interesting? My
particular use case was benchmarking. I wanted to repeatedly measure
the timing when things were read from disk. Dropping everything from
the cache, also drops useful things, not just the few files your
benchmark intends to measure.

Why /proc? Because this is where the current drop_caches mechanism is
located. If it should go somewhere else, please do suggest so.

The string is a path, i.e., can be either a file or a directory. In
case of a directory, we recursively drop all its contents.

Why not use posix_fadvice()? Because it is exactly this, an advice.
The kernel is free to do whatever, i.e., also ignore the request. We
want a mechanism that reliably drops select content from the cache.
