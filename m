Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaKYRTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:19:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:25656 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKYRTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:19:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,456,1413270000"; 
   d="scan'208";a="613861169"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Topic: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Index: AQHQCAJK8ZnshsuiH02FNfwCATHuw5xwvrCAgADMslA=
Date: Tue, 25 Nov 2014 17:19:23 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701676387@SHSMSX103.ccr.corp.intel.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
 <1416844829-26945-3-git-send-email-kan.liang@intel.com>
 <20141125122159.GF30861@krava.brq.redhat.com>
In-Reply-To: <20141125122159.GF30861@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +	data__for_each_file_new(i, d) {
> > +		k_dsos_tmp = &d->session->machines.host.kernel_dsos;
> > +		u_dsos_tmp = &d->session->machines.host.user_dsos;
> > +
> > +		if (!dsos__build_ids_equal(base_k_dsos, k_dsos_tmp))
> > +			pr_warning("The perf.data come from different
> kernel. "
> > +				   "The kernel symbol offset may vary for
> different kernel.\n");
> > +
> > +		if (!dsos__build_ids_equal(base_u_dsos, u_dsos_tmp))
> 
> looks like at this time not all dsos on the list have the buildids read..
> 

Right, I shouldn't assume all dsos have biuldids. I will modify the
dsos__build_ids_equal to check has_build_id.
If neither dsos have build_id, it will print
pr_debug ("Cannot get build_id for all dsos\n") once, and continue to do
next dso compare.

All the buildid compare related warnings will also be printed once.

> I tried to put in here the perf_session__read_build_ids call but it keeps
> showing me warning below:
> 
> > +			pr_warning("The perf.data come from different
> user binary. "
> > +				   "The user space symbol offset may vary
> for different
> > +binaries.\n");
> 
> for following workload:
> 
> [jolsa@krava perf]$ ./perf record ls
> ...
> [ perf record: Woken up 1 times to write data ] [ perf record: Captured and
> wrote 0.012 MB perf.data (~540 samples) ] [jolsa@krava perf]$ ./perf
> record ls ...
> [ perf record: Woken up 1 times to write data ] [ perf record: Captured and
> wrote 0.012 MB perf.data (~540 samples) ] [jolsa@krava perf]$ ./perf diff -
> s symoff The perf.data come from different user binary. The user space
> symbol offset may vary for different binaries.
> # Event 'cycles'
> ...

Another reason for the false warning is that we use long_name to find the dso_b.
However, the long_name is not unique.
The vmlinux dso is added when processing header. Its long name and short name
are same. (E.g. /lib/modules/3.18.0-rc3-01635-g05066a2-dirty/build/vmlinux)
When processing sample, vmlinux is loaded. Two new dsos are added for section
"init.text" and "exit.text".  They also have the long name
/lib/modules/3.18.0-rc3-01635-g05066a2-dirty/build/vmlinux. But their short
name are different, [kernel.vmlinux].init.text and [kernel.vmlinux].exit.text.

So I will change the dsos__build_ids_equal to find the dso by short_name.

Kan
> 
> 
> jirka
