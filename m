Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbbAJQFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 11:05:21 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:45737 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbAJQFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 11:05:20 -0500
Date: Sat, 10 Jan 2015 11:05:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
        vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Message-ID: <20150110160515.GB25319@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
 <20150106214426.GA24106@htj.dyndns.org>
 <20150107234532.GD25000@dastard>
 <20150109212336.GB2785@htj.dyndns.org>
 <20150110003819.GP31508@dastard>
 <20150110155653.GA25319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110155653.GA25319@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 10:56:53AM -0500, Tejun Heo wrote:
...
> backpressure propagation.  If you start mixing pages from different
> cgroups in a single bio, the only options for handling it from the
> lower layer is either splitting it into two separate requests and
> finish the bio only on completion of both or choosing one victim
> cgroup, essentially arbitrarily, both of which can lead to gross
> priority inversion in many circumstances.

Another aspect to consider here is that cfq-iosched doesn't even issue
IOs from different cgroups at the same time.  It schedules time slices
for different cgroups and at any given time only issues a stream of
IOs from a single cgroup.  This is mainly because it's impossible to
determine how much time the target device to process a specific IO
request, especially when it's a write.  The only way we can
approxmiate the cost with an acceptable level of accuracy is bunching
multiple IOs up and then measure the time to finish them in groups so
that the the deviations can be spread across multiple requests.  This
means that we can't issue IOs belonging to different cgroups at the
same time because we can't account for the divisions of cost for the
different cgroups.

Thanks.

-- 
tejun
