Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaDBOwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:52:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:57070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbaDBOwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:52:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="505366431"
Message-ID: <1396450314.11878.90.camel@empanada>
Subject: Re: About 'hash' event trigger patchset
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 Apr 2014 09:51:54 -0500
In-Reply-To: <CAM9d7ch-ZBYRHmhbHJEXQtS-V_kBPK5nMhtM3bPbHmnY+m-EeQ@mail.gmail.com>
References: <CAM9d7ch-ZBYRHmhbHJEXQtS-V_kBPK5nMhtM3bPbHmnY+m-EeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On Wed, 2014-04-02 at 08:31 +0000, Namhyung Kim wrote:
> Hi Tom,
> 
> (Sorry for replying in another thread, I have a problem on mail settings)
> 
> I've just read your hash event trigger series, and want to give some feedback.
> 
> At first, the change log of 5/5 is actually a better documentation
> than in patch 4/5 so I think it should be added to the doc also.  But

Good point, I'll do that (after trimming it down a bit).

> the syntax of the hash trigger should be look like:
> 
> - # echo hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger
> + # echo hash:key(s):value(s)[:"sort="sort_key(s)][ if filter] > event/trigger
> 
> Also on first example in the changelog of 5/5, key should be
> 'stacktrace' instead of 'call_site'.
> 

Yeah, I realized that just after posting - will fix.

> As far as I see in the code, the sort key can receive an optional
> descending/ascending modifier, but it's not documented.
> 

I knew I was forgetting something ;-)  Thanks for pointing it out.

> One thing I noticed in the main logic is that it seems there's no
> limit checking when adding/creating new entry.  In
> hash_trigger_entry_create(), there's a check against max_entries but
> if it goes beyond the max, it'd just access a NULL pointer AFAICS.  Am
> I missing something?  Also I don't know what the difference between
> ->n_entries and ->total_entries (in hash_data).
> 
> I guess you wanted to set ->drops in that case, but I cannot find

Yes, the code is missing a very important snippet, which I realized
after hitting the problem.  My current code has this:

        if (hash_data->drops)
                return NULL;
        else if (hash_data->n_entries == hash_data->max_entries) {
                hash_data->drops = 1;
                return NULL;
        }

n_entries is the current number of entries used up, and max_entries is
the total number of available entries (a cached value to avoid
calculating it every time).

> where it gets set.  And I'm not sure it's good to check ->drop first,
> since entry can find an existing entry and merged to it even if it
> reached the max already.
> 

The assumption is that if you have any drops at all, you probably want
to redo the test with a bigger table, but regardless the data reflects
the situation up to the point the drops started happening.  Letting
events that already have a entry merge while rejecting those that don't
would invalidate the data you already have.

Thanks for taking a look and for your helpful comments,

Tom

> Thanks,
> Namhyung


