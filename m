Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaA3Qim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:38:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaA3Qil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,750,1384329600"; 
   d="scan'208";a="475237824"
Message-ID: <52EA7F35.8020500@intel.com>
Date: Thu, 30 Jan 2014 18:35:01 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 9/9] perf buildid-cache: Check relocation when checking
 for existing kcore
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com> <1391004884-10334-10-git-send-email-adrian.hunter@intel.com> <20140129191454.GG3998@ghostprotocols.net> <52EA1CAE.7060801@intel.com> <20140130141821.GA30054@ghostprotocols.net>
In-Reply-To: <20140130141821.GA30054@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/2014 4:18 p.m., Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 30, 2014 at 11:34:38AM +0200, Adrian Hunter escreveu:
>> On 29/01/14 21:14, Arnaldo Carvalho de Melo wrote:
>>> Em Wed, Jan 29, 2014 at 04:14:44PM +0200, Adrian Hunter escreveu:
>>>> perf buildid-cache does not make another
>>>> copy of kcore if the buildid and modules
>>>> match an existing copy.  That does not
>
>>> Humm, what is the problem? Having the ref reloc symbol we can fix things
>>> up, no? I.e. just using map->reloc the old kcore copy should be ok to
>>> use, no need to replace the kcore copy in the cache. Or am I missing
>>> something?
>
>> The current implementation works on the basis that kcore matches the
>> perf data recorded.  This is just a fix for that.
>
>> I am afraid it is that way because it meets my needs.
>
>> I did not think of allowing for relocation because I need to be able
>> to walk the code.  Relocation was one of the things I was trying to
>> avoid.
>
>> For me making a copy of kcore is far superior because it can be made
>> to have the jump labels mostly the right way around too. e.g. run a
>> dummy perf record while making the copy.
>
> Yes, it is superior, no question about it, I'm just trying to figure out
> how this fits into the build-id cache thing, i.e. it should have files
> keyed by its build-id, that are inserted, but not replaced, since it
> expects its contents to be constant.
>
> So you have a need to get the matching kcore at the time you did the
> record, because we're dealing with self modifying code, the kernel (soon
> if not already, userspace as well)...
>
> So at least we need to make this abundantly clear to users, that what is
> in the build-id cache may be the latest snapshot of some DSO that had a
> build-id at, well, build time.
>
> We need to add support for looking up in the binary where are places
> that are modifiable and then mark those in the UI using some visual cue.
>
> Till then, at least a paragraph in the documentation stating what
> happens is needed, I'll look into it.
>
> And then right now this is just for kcore, that is clearly marked as
> such in the build-id cache, IIRC it is in a separate directory, etc,
> right?

Yes, perf buidid-cache creates a directory in the cache of the form:

	[kernel.kcore]/<build-id>/<YYYYmmddHHMMSShh>

which contains 3 files: kcore, kallsyms and modules.
