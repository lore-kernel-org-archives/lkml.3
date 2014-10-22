Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaJVGpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:45:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49550 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJVGpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:45:46 -0400
Message-ID: <54475292.20409@hitachi.com>
Date: Wed, 22 Oct 2014 15:45:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105914.15506.84827.stgit@hemant-fedora>
In-Reply-To: <20141010105914.15506.84827.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

(2014/10/10 19:59), Hemant Kumar wrote:
> The SDT events are already stored in a cache file
> (/var/cache/perf/perf-sdt-file.cache).

Please describe what this patch does at first.


> Although the file_hash table helps in addition or deletion of SDT events from the
> cache, its not of much use when it comes to probing the actual SDT event,
> because the key to this hash list is a file name and not the SDT event name
> (which is given as an argument to perf record). So, we won't be able to hash
> into it.
> 
> To avoid this problem, we can create another hash list "event_hash" list which
> will be maintained along with the file_hash list.
> Whenever a user invokes 'perf record -e %provider:event, perf should initialize
> the event_hash list and the file_hash list.
> The key to event_hash list is calculated from the event name and its
> provider name.
> 
>             event_hash       sdt_note
>             |---------|   ----------------
>             |         |   |   file_ptr   |==> container file_sdt_ent
> key = 129 =>| hlist ==|===|=> event_list=|==> to sdt notes hashed to
>        	    |         |   |   name       |    same entry
>             |---------|   |   provider   |
>             |	      |   |   note_list==|==> to other notes in the
> key = 130 =>| hlist   |   ---------------     same file
>             |---------|
> 
> The entry at that key in event_hash contains a list of SDT notes hashed to the
> same entry. It compares the name and provider to see if that is the SDT note we
> are looking for. If yes, find out the file that contains this SDT note. There is
> a file_ptr pointer embedded in this note which points to the struct file_sdt_ent
> contained in the file_hash. From "file_sdt_ent" we will find out the file name.
> Convert this sdt note into a perf event and then write this into uprobe_events
> file to be able to record the event.
> Then, corresponding entries are added to uprobe_events file for
> the SDT events.
> After recording is done, these events are silently deleted from uprobe_events
> file. The uprobe_events file is present in debugfs/tracing directory.
> 
> To support the addition and deletion of SDT events to/from uprobe_events
> file, a record_sdt struct is maintained which has the event data.

OK, I have some comments on this.

> An example usage:
> 
> # ./perf record -e %user_app:fun_start -aR /home/user_app

At first, I'd like to add SDT support for adding probes too, like below;

./perf probe -a '%user_app:fun_start $vars'

So, maybe we don't need to remove the SDT-based events silently, nor
hide it from users. I think you just need to add new sdt events and
verify it if there is.

BTW, for silently adding event, I'll introduce --quite(-q) option for
perf probe. So you'll just need to set silent flag with that.


Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


