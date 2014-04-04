Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaDDHg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:36:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34679 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaDDHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:36:52 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: About 'hash' event trigger patchset
References: <CAM9d7ch-ZBYRHmhbHJEXQtS-V_kBPK5nMhtM3bPbHmnY+m-EeQ@mail.gmail.com>
	<1396450314.11878.90.camel@empanada>
Date: Fri, 04 Apr 2014 16:36:50 +0900
In-Reply-To: <1396450314.11878.90.camel@empanada> (Tom Zanussi's message of
	"Wed, 02 Apr 2014 09:51:54 -0500")
Message-ID: <87vbupy299.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Wed, 02 Apr 2014 09:51:54 -0500, Tom Zanussi wrote:
> Hi Namhyung,
>
> On Wed, 2014-04-02 at 08:31 +0000, Namhyung Kim wrote:
>> One thing I noticed in the main logic is that it seems there's no
>> limit checking when adding/creating new entry.  In
>> hash_trigger_entry_create(), there's a check against max_entries but
>> if it goes beyond the max, it'd just access a NULL pointer AFAICS.  Am
>> I missing something?  Also I don't know what the difference between
>> ->n_entries and ->total_entries (in hash_data).
>> 
>> I guess you wanted to set ->drops in that case, but I cannot find
>
> Yes, the code is missing a very important snippet, which I realized
> after hitting the problem.  My current code has this:
>
>         if (hash_data->drops)
>                 return NULL;

I think this part can be omitted since it's already checked earlier.
But it's a minor issue.


>         else if (hash_data->n_entries == hash_data->max_entries) {
>                 hash_data->drops = 1;
>                 return NULL;
>         }
>
> n_entries is the current number of entries used up, and max_entries is
> the total number of available entries (a cached value to avoid
> calculating it every time).

But there's "total_entries" - increased in hash_trigger_entry_insert() -
too and I think it's just same as n_entries.

>
>> where it gets set.  And I'm not sure it's good to check ->drop first,
>> since entry can find an existing entry and merged to it even if it
>> reached the max already.
>> 
>
> The assumption is that if you have any drops at all, you probably want
> to redo the test with a bigger table, but regardless the data reflects
> the situation up to the point the drops started happening.  Letting
> events that already have a entry merge while rejecting those that don't
> would invalidate the data you already have.

Okay, I won't insist on it.

Thanks,
Namhyung
