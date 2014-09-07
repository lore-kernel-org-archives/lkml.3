Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaIGVBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 17:01:06 -0400
Received: from mail1.SerNet.de ([193.175.80.2]:37383 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaIGVBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 17:01:05 -0400
X-Greylist: delayed 708 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2014 17:01:04 EDT
Date: Sun, 7 Sep 2014 22:48:51 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Milosz Tanski <milosz@adfin.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-aio@kvack.org
Subject: Re: read()/readv() only from page cache
Reply-To: Volker.Lendecke@SerNet.DE
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
 <20140905110927.GI17501@suse.de>
 <20140905154829.GA22956@infradead.org>
 <CANP1eJEdH8Hk-i348N3YQ4FUoSGb-2Tp9g9ZJxnKO1zZskTKjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP1eJEdH8Hk-i348N3YQ4FUoSGb-2Tp9g9ZJxnKO1zZskTKjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1XQjOX-00CcnG-UC@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:27:21PM -0400, Milosz Tanski wrote:
> In a VLDB like workload this would enable me to lower the latency of
> common fast requests and. By fast requests I mean ones that do not
> require much data, the data is cached, or there's a predictable read
> pattern (read-ahead). Obviously it would be at the expense of the
> latency of large/slow requests (they have to make 2 read calls, the
> first one always EWOULDBLOCK) ... but in that case it doesn't matter
> since the time to do actual IO would trump any kind of extra latency.

That was my thinking as well when I discussed it with Christoph. Sorry
for not getting around to actually test his patch. Samba right
now uses a thread pool for aio, we get parallel read requests from
clients over a single TCP connection and we need to keep all disks busy
simultaneously. We'd like to avoid the thread overhead when it's not
necessary because the data is already around. A per-request flag would
fit Samba better than a flag settable by fcntl in this pattern. Samba
can't easily open a file twice (once with NONBLOCK and once without).

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
