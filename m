Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3FJOeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:34:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:42048 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3FJOeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,837,1363158000"; 
   d="scan'208";a="351114724"
Date: Mon, 10 Jun 2013 22:30:16 +0800
From: Feng Tang <feng.tang@intel.com>
To: Emmet Caulfield <emmet.caulfield@stanford.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf script: turn AUTOCOMMIT off for bulk SQL inserts in
 event_analyzing_sample.py
Message-ID: <20130610143016.GA2124@feng-snb>
References: <CA+nN=O9dnp-j48fb1MAKLh=gdtMqY8o0kkL5jM3eSFbp04whaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+nN=O9dnp-j48fb1MAKLh=gdtMqY8o0kkL5jM3eSFbp04whaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:58:53AM -0700, Emmet Caulfield wrote:
> The example script tools/perf/scripts/python/event_analyzing_sample.py
> contains a minor error. This script takes a perf.data file and
> populates a SQLite database with it.
> 
> There's a long comment on lines 29-34 to the effect that it takes a
> long time to populate the database if the .db file is on disk, so it's
> done in the "ramdisk" (/dev/shm/perf.db), but the problem here is
> actually line 36:
> 
>     con.isolation_level=None
> 
> This line turns on AUTOCOMMIT, making every INSERT statement into its
> own transaction, and greatly slowing down a bulk insert (25 minutes
> vs. a few seconds to insert 15,000 records). This is best solved by
> merely omitting this line or changing it to:
> 
>     con.isolation_level='DEFERRED'
> 
> After making this change, if the database is in memory, it takes
> roughly 0.5 seconds to insert 15,000 records and 0.8 seconds if the
> database file is on disk, effectively solving the problem.
> 
> Given that the whole purpose of having AUTOCOMMIT turned on is to
> ensure that individual insert/update/delete operations are committed
> to persistent storage, moving the .db file to a ramdisk defeats the
> purpose of turning this option on in the first place. Thus
> leaving/turning it *off* with the file on disk is no worse. It is
> pretty much standard practice to defer transactions and index updates
> for bulk inserts like this anyway.
> 
> The following patch deletes the offending line and updates the
> associated comment.
> 
> Emmet.
> 
> 
> --- tools/perf/scripts/python/event_analyzing_sample.py~
> 2013-06-03 15:38:41.762331865 -0700
> +++ tools/perf/scripts/python/event_analyzing_sample.py 2013-06-03
> 15:43:48.978344602 -0700
> @@ -26,14 +26,9 @@
>  from perf_trace_context import *
>  from EventClass import *
> 
> -#
> -# If the perf.data has a big number of samples, then the insert operation
> -# will be very time consuming (about 10+ minutes for 10000 samples) if the
> -# .db database is on disk. Move the .db file to RAM based FS to speedup
> -# the handling, which will cut the time down to several seconds.
> -#
> +# Create/connect to a SQLite3 database:
>  con = sqlite3.connect("/dev/shm/perf.db")
> -con.isolation_level = None
> +
> 
>  def trace_begin():
>         print "In trace_begin:\n"

Thanks for the root causing the slowness of SQLite3 operation.

Acked-by: Feng Tang <feng.tang@intel.com>

