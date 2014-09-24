Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaIXP3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:29:16 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:47639 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaIXP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:29:12 -0400
Message-ID: <5422E343.6090605@hp.com>
Date: Wed, 24 Sep 2014 11:29:07 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v3 1/2] perf tool: improves DSO long names search speed
 with RB tree
References: <1411047021-38823-1-git-send-email-Waiman.Long@hp.com> <1411047021-38823-2-git-send-email-Waiman.Long@hp.com> <20140918151057.GG2770@kernel.org>
In-Reply-To: <20140918151057.GG2770@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 11:10 AM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 18, 2014 at 09:30:20AM -0400, Waiman Long escreveu:
>> +++ b/tools/perf/util/dso.c
>> @@ -651,6 +651,80 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>>   	return dso;
>
>> +/*
>> + * RB root of DSOs sorted by the long name
>> + */
>> +struct rb_root dso__root = { NULL };
> Why do we still have a global variable for this? I thought that we would
> be having this in struct machine?
>
> Ok, I shouldn't have done this, but I went on and looked at the second
> patch, and there, this goes away, why not avoid introducing the global
> in the first place?

The global variable was added to make the first patch compilable by 
itself. I will take this out in the next version of the patch.

> I.e. the existing code operates on a data structure that holds struct
> dsos, you are switching to a new data structure, so it looked natural to
> me to do this in one step, no?

Yes, I think that makes sense.

> Also at some point I thought about adding rb_tree helper functions to do
> some rb__for_each() like operation, i.e. to sequentially access the
> rb_tree instead of using it for searching using its key. PeterZ
> rightfully nacked that because that would, IIRC, encourage people to use
> a rb_tree to do linear searches for normal operation, i.e. not just for
> rb_tree__printf() dump like routines:
>
> https://lkml.org/lkml/2010/1/13/227
>
> Also I saw at least one place where some foo__for_each_entry_safe() is
> used but the loop doesn't look like it will remove/add anything to the
> data structure that is being made "_safe", i.e. it should remain
> foo__for_each_entry(), as it was before.
>
> So, I would _keep_ the list_head, or else replace it with a another
> rb_node to do lookups on it by shortname the same way we do for long
> names.
>
> The cheapest thing now would be for solving your problem, i.e. use a
> rb_tree for searching for long names, keep the list_head for short names
> linear searches.
>
> I suggest having a
>
> struct dsos {
> 	struct list_head short_names;
> 	struct rb_root	 long_names;
> };
>
> Then make struct machine use this type for:
>
> 	struct dsos	kernel_dsos, user_dsos;
>
> Then all those dsos__find* routines stop receiving a list_head pointer
> and start receiving a "struct dsos" instance.
>
> That way it can add the dso to both containers, the one "sorted" by
> short names (that linear search, just like before) and to the rb_tree
> sorted by long names.
>
> - Arnaldo

I think this is a good idea. I will incorporate that in my next patch. 
BTW, the list isn't sorted in any way. So I won't use the same structure 
field names as you have suggested.


-Longman
