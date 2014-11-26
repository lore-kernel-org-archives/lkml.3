Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaKZQLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:11:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:30506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaKZQLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:11:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,462,1413270000"; 
   d="scan'208";a="628639182"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Topic: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Index: AQHQCAJK8ZnshsuiH02FNfwCATHuw5xwtk+AgAJdcDA=
Date: Wed, 26 Nov 2014 16:10:51 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770167680F@SHSMSX103.ccr.corp.intel.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
 <1416844829-26945-3-git-send-email-kan.liang@intel.com>
 <20141125115159.GE30861@krava.brq.redhat.com>
In-Reply-To: <20141125115159.GE30861@krava.brq.redhat.com>
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


> 
> On Mon, Nov 24, 2014 at 11:00:29AM -0500, Kan Liang wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > symoff can support both same binaries and different binaries. However,
> > the offset may be changed for different binaries. This patch checks
> > the buildid of perf.data. If they are from different binaries, print a
> > warning to notify the user.
> >
> > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > ---
> >  tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++++
> >  tools/perf/util/sort.c    |  3 +++
> >  tools/perf/util/sort.h    |  1 +
> >  3 files changed, 29 insertions(+)
> >
> > diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> > index 03a4001..2a8c17a 100644
> > --- a/tools/perf/builtin-diff.c
> > +++ b/tools/perf/builtin-diff.c
> > @@ -678,6 +678,28 @@ static void data__free(struct data__file *d)
> >  	}
> >  }
> >
> > +static void buildid_check(void)
> > +{
> > +	struct dsos *base_k_dsos = &data__files[0].session-
> >machines.host.kernel_dsos;
> > +	struct dsos *base_u_dsos = &data__files[0].session-
> >machines.host.user_dsos;
> > +	struct dsos *k_dsos_tmp, *u_dsos_tmp;
> > +	struct data__file *d;
> > +	int i;
> > +
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
> > +			pr_warning("The perf.data come from different
> user binary. "
> > +				   "The user space symbol offset may vary
> for different
> > +binaries.\n");
> 
> we dont specify the kernel version or dso path in the warning message,
> maybe we want to print it out just once? In case there's more than 2 not
> matching data?
 
Could we print the header instead? It should be more informative. 
Maybe we can print it with --verbose.

What do you think about the patch as below?

+static void buildid_check(void)
+{
+       struct dsos *base_k_dsos = &data__files[0].session->machines.host.kernel_dsos;
+       struct dsos *base_u_dsos = &data__files[0].session->machines.host.user_dsos;
+       struct dsos *k_dsos_tmp, *u_dsos_tmp;
+       struct data__file *d;
+       bool k_warn, u_warn;
+       bool first = true;
+       int i;
+
+       data__for_each_file_new(i, d) {
+               k_dsos_tmp = &d->session->machines.host.kernel_dsos;
+               u_dsos_tmp = &d->session->machines.host.user_dsos;
+
+               k_warn = !dsos__build_ids_equal(base_k_dsos, k_dsos_tmp);
+               u_warn = !dsos__build_ids_equal(base_u_dsos, u_dsos_tmp);
+
+               if (k_warn || u_warn) {
+                       pr_warning("The perf.data come from different %s%s%s. "
+                                  "The symbol offset may vary.\n",
+                                  k_warn ? "kernel" : "",
+                                  (k_warn && u_warn) ? " and " : "",
+                                  u_warn ? "user bunary" : "");
+
+                       if (verbose) {
+                               if (first) {
+                                       fprintf(stdout, "# ========%s (Baseline)\n", data__files[0].file.path);
+                                       perf_header__fprintf_info(data__files[0].session, stdout, false);
+                                       fprintf(stdout, "# ========\n#\n");
+                                       first = false;
+                               }
+                               fprintf(stdout, "# ========%s\n", d->file.path);
+                               perf_header__fprintf_info(d->session, stdout, false);
+                               fprintf(stdout, "# ========\n#\n");
+                       }
+               }
+       }
+}


> 
> jirka
