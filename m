Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaESLqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaESLqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:46:20 -0400
Date: Mon, 19 May 2014 13:45:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/6] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Message-ID: <20140519114539.GE5027@krava.brq.redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-3-git-send-email-dzickus@redhat.com>
 <20140516112514.GC19475@krava.brq.redhat.com>
 <20140516132630.GM50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516132630.GM50500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 09:26:30AM -0400, Don Zickus wrote:
> On Fri, May 16, 2014 at 01:25:14PM +0200, Jiri Olsa wrote:
> > On Tue, May 13, 2014 at 12:48:13PM -0400, Don Zickus wrote:
> > 
> > SNIP
> > 
> > > -		/*
> > > - 		 * Anon maps don't have the execname.
> > > - 		 */
> > > -		if (n < 4)
> > > +		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
> > > +		       &event->mmap2.start, &event->mmap2.len, prot,
> > > +		       &event->mmap2.pgoff, &event->mmap2.maj,
> > > +		       &event->mmap2.min,
> > > +		       &ino, execname);
> > > +
> > > +		event->mmap2.ino = (u64)ino;
> > > +
> > > +		if (n < 7)
> > >  			continue;
> > 
> > any reason for changing this from 'if (n != 8)' ?
> 
> Yes, read 9d4ecc8893832337daf241236841db966fa53489. :-)
> 
> This wasn't a clean revert because of the change for (n != 5) -> (n < 4).
> So I maintainted the spirit of the upstream code with this revert.  Let me
> know if that is wrong.

ook, I found another issue.. perf test 25 is failing, because
it's using perf_event__synthesize_mmap_events to store map events
plus machine__process_mmap_event to feed them into machine object

it needs to use machine__process_mmap2_event now, because
perf_event__synthesize_mmap_events uses MMAP2 events now
please check attached patch

I think it's better to have this hunk in this patch, so we dont
break tests.. also please run them ebfore posting patch

please update the changelog to have some info about this.. plus
the Revert reason info and plus the 'if (n != 8)' thing ;-)

thanks,
jirka

---
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 108f0cd..96adb73 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -15,7 +15,7 @@ static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			struct perf_sample *sample __maybe_unused,
 			struct machine *machine)
 {
-	return machine__process_mmap_event(machine, event, NULL);
+	return machine__process_mmap2_event(machine, event, NULL);
 }
 
 static int init_live_machine(struct machine *machine)
