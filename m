Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3JQOsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:48:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab3JQOsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="asc'?scan'208";a="418434211"
Date: Thu, 17 Oct 2013 10:33:48 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, tony.luck@intel.com, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131017143348.GA3891@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>, tony.luck@intel.com,
	joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
	arozansk@redhat.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <20131016160550.GG13608@pd.tnic>
 <20131016125646.7141b580@gandalf.local.home>
 <20131016180038.GO13608@pd.tnic>
 <20131016181117.GP13608@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20131016181117.GP13608@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 08:11:17PM +0200, Borislav Petkov wrote:
> Date: Wed, 16 Oct 2013 20:11:17 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: Steven Rostedt <rostedt@goodmis.org>, "Chen, Gong"
>  <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
>  arozansk@redhat.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Wed, Oct 16, 2013 at 08:00:38PM +0200, Borislav Petkov wrote:
> > Right, the only difference I can see is that include/ras/ras_event.h
> > doesn't have those below:
> >=20
> > #undef TRACE_INCLUDE_PATH
> > #undef TRACE_INCLUDE_FILE
> > #define TRACE_INCLUDE_PATH .
> >=20
> > Perhaps that is the problem?
> >=20
> > Gong, what is exactly the issue you're observing?
>=20
> Ok, I think I know what the issue is:
>=20
> Gong has
>=20
> diff --git a/drivers/acpi/extlog_trace.c b/drivers/acpi/extlog_trace.c
> new file mode 100644
> index 000000000000..28640807fb09
> --- /dev/null
> +++ b/drivers/acpi/extlog_trace.c
> @@ -0,0 +1,107 @@
> +#include <linux/export.h>
> +#include <linux/dmi.h>
> +#include "extlog_trace.h"
> +
> +#define CREATE_TRACE_POINTS
> +#define TRACE_INCLUDE_PATH ../../include/ras
> +#include <ras/ras_event.h>
>=20
> for the ras tracepoint although this is done already in
> drivers/edac/edac_mc.c
>=20

Sorry I don't express clearly enough. The patch [v2 9/9] in this patch
seris can work well. The bogus one is in myself reply for patch [v2 0/9].
In this patch series I keep trace interface always builtin, so it can
work for module & builtin, whether CREATE_TRACE_POINTS is defined
multi-times or not.

The weird thing for bogus patch is if it is compiled as a module, I can
find the trace_xxx function is called definitely and paramerters are
expected but nothing output via trace interface, just like below:

# tracer: nop
#
# entries-in-buffer/entries-written: 0/0   #P:120
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |


I highly suspect my trace_xxx function is compiled as an empty function
if following my bogus patch.

> Gong, can you try moving the CREATE_TRACE_POINTS line to a new file -
> arch/x86/ras/ras.c and define it there and not anywhere else, i.e. move
> it away from edac_mc.c. Does that help?

In current kernel we haven't arch/x86/ras/ras.c. You mean I create
a new one there and just add some trace macro definition?

>=20
> Also, see Documentation/trace/tracepoints.txt for more info.
>=20
> HTH.
>=20
> --=20
> Regards/Gruss,
>     Boris.
>=20
> Sent from a fat crate under my desk. Formatting is fine.
> --

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSX/VMAAoJEI01n1+kOSLHlpEP/jJ/ENGp0FR45RfrolH1mIJW
uKMZTX1EmBPY5Bd5NHZwF7+ORRbZPZzfLmNUGYBAHcOUFPSDgUhozzkIair9rJvx
umMt6O3mUv3GI29rvVMsf1MhZglWLUZdy8X7rkYQmtS0AuJT+OfbyyMUqvidHn4N
YB23J/hjSl1AAyd6UfX4Aj+MlEM0phyHQZQtjWV9py7Wp9iXfN7Gic+SI3CLcR4z
hm/Muhy29J5HtheD1p1XI+Hpr/MZGWZ+6jFaUVBLT9RW37S+oV6BIH7GhxoTc/LY
tj+zXFGwkgAJeA87oCOBwlkvtraE0B+IvOyR+MPctrolQB0O3VN3HUJ98L9pJ/PS
f2CqpLH7f1Zu6yG2qb0aZmymYCDWFpBbdlhfdd+UMgfWtGt1JVdL2sRerT0qwqAT
GGVZ2HFbgjPj9SepssGHj+VngEXN6tqNGuTFfpYOLPmmcNJuiG63JM22V0CJlE9Y
w+Hsac571jvaOqATDfUyyJi+6mf3GCgnq7cxS1cAN6tH/KPl3zYywr/t6VdoZVH8
LPmA63tEtOP3CPDsj4PGvuxSS33d9TnWPT8E7aQoDaHC5yvYzvZGxv+f+tyRhj9M
xocWg/7R2xmrMFdMcNAgs6iJ7pFaSmqolZAVvD5EWcmoSrElW7J7FTnGlJ6u2mcS
1n/RUlHFsZgPlwFKY19B
=GB0+
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
