Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaDESr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 14:47:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:2332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaDESrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 14:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,801,1389772800"; 
   d="scan'208";a="487912914"
Message-ID: <1396723664.3035.35.camel@empanada>
Subject: Re: About 'hash' event trigger patchset
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 05 Apr 2014 13:47:44 -0500
In-Reply-To: <87vbupy299.fsf@sejong.aot.lge.com>
References: <CAM9d7ch-ZBYRHmhbHJEXQtS-V_kBPK5nMhtM3bPbHmnY+m-EeQ@mail.gmail.com>
	 <1396450314.11878.90.camel@empanada> <87vbupy299.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On Fri, 2014-04-04 at 16:36 +0900, Namhyung Kim wrote:
> Hi Tom,
> 
> On Wed, 02 Apr 2014 09:51:54 -0500, Tom Zanussi wrote:
> > Hi Namhyung,
> >
> > On Wed, 2014-04-02 at 08:31 +0000, Namhyung Kim wrote:
> >> One thing I noticed in the main logic is that it seems there's no
> >> limit checking when adding/creating new entry.  In
> >> hash_trigger_entry_create(), there's a check against max_entries but
> >> if it goes beyond the max, it'd just access a NULL pointer AFAICS.  Am
> >> I missing something?  Also I don't know what the difference between
> >> ->n_entries and ->total_entries (in hash_data).
> >> 
> >> I guess you wanted to set ->drops in that case, but I cannot find
> >
> > Yes, the code is missing a very important snippet, which I realized
> > after hitting the problem.  My current code has this:
> >
> >         if (hash_data->drops)
> >                 return NULL;
> 
> I think this part can be omitted since it's already checked earlier.
> But it's a minor issue.
> 

Right, exactly, it's completely redundant.

> 
> >         else if (hash_data->n_entries == hash_data->max_entries) {
> >                 hash_data->drops = 1;
> >                 return NULL;
> >         }
> >
> > n_entries is the current number of entries used up, and max_entries is
> > the total number of available entries (a cached value to avoid
> > calculating it every time).
> 
> But there's "total_entries" - increased in hash_trigger_entry_insert() -
> too and I think it's just same as n_entries.
> 

And this is too - in a previous version they could be different, but
you're right, n_entries is sufficient now - I'll consolidate in the next
version.

Thanks,

Tom

> >
> >> where it gets set.  And I'm not sure it's good to check ->drop first,
> >> since entry can find an existing entry and merged to it even if it
> >> reached the max already.
> >> 
> >
> > The assumption is that if you have any drops at all, you probably want
> > to redo the test with a bigger table, but regardless the data reflects
> > the situation up to the point the drops started happening.  Letting
> > events that already have a entry merge while rejecting those that don't
> > would invalidate the data you already have.
> 
> Okay, I won't insist on it.
> 
> Thanks,
> Namhyung


