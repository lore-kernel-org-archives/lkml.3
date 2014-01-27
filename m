Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaA0Ovi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:51:38 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16488 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaA0Ovg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:51:36 -0500
Message-ID: <1390833923.1792.507.camel@misato.fc.hp.com>
Subject: Re: [tip:x86/urgent] arch/x86/mm/srat: Skip NUMA_NO_NODE while
 parsing SLIT
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Mon, 27 Jan 2014 07:45:23 -0700
In-Reply-To: <CAE9FiQXSc5ynXcrwcc6K-3sM8PZ=n+ieiR4h1P-gjd4Eknmnww@mail.gmail.com>
References: <tip-a85eba8814631d0d48361c8b9a7ee0984e80c03c@git.kernel.org>
	 <CAE9FiQXSc5ynXcrwcc6K-3sM8PZ=n+ieiR4h1P-gjd4Eknmnww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-26 at 00:43 -0800, Yinghai Lu wrote:
> On Sat, Jan 25, 2014 at 6:25 AM, tip-bot for Toshi Kani
> <tipbot@zytor.com> wrote:
> > Commit-ID:  a85eba8814631d0d48361c8b9a7ee0984e80c03c
> > Gitweb:     http://git.kernel.org/tip/a85eba8814631d0d48361c8b9a7ee0984e80c03c
> > Author:     Toshi Kani <toshi.kani@hp.com>
> > AuthorDate: Tue, 21 Jan 2014 14:33:15 -0800
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sat, 25 Jan 2014 09:13:35 +0100
> >
> > arch/x86/mm/srat: Skip NUMA_NO_NODE while parsing SLIT
> >
> > When ACPI SLIT table has an I/O locality (i.e. a locality
> > unique to an I/O device), numa_set_distance() emits this warning
> > message:
> >
> >  NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
> >
> > acpi_numa_slit_init() calls numa_set_distance() with
> > pxm_to_node(), which assumes that all localities have been
> > parsed with SRAT previously.  SRAT does not list I/O localities,
> > where as SLIT lists all localities including I/Os.  Hence,
> > pxm_to_node() returns NUMA_NO_NODE (-1) for an I/O locality.
> >
> > I/O localities are not supported and are ignored today, but emitting
> > such warning message leads to unnecessary confusion.
> >
> > Change acpi_numa_slit_init() to avoid calling
> > numa_set_distance() with NUMA_NO_NODE.
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Link: http://lkml.kernel.org/n/tip-dSvpjjvp8aMzs1ybkftxohlh@git.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
> >  arch/x86/mm/srat.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> > index 266ca91..5ecf651 100644
> > --- a/arch/x86/mm/srat.c
> > +++ b/arch/x86/mm/srat.c
> > @@ -42,15 +42,25 @@ static __init inline int srat_disabled(void)
> >         return acpi_numa < 0;
> >  }
> >
> > -/* Callback for SLIT parsing */
> > +/*
> > + * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
> > + * I/O localities since SRAT does not list them.  I/O localities are
> > + * not supported at this point.
> > + */
> >  void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
> >  {
> >         int i, j;
> >
> > -       for (i = 0; i < slit->locality_count; i++)
> > -               for (j = 0; j < slit->locality_count; j++)
> > +       for (i = 0; i < slit->locality_count; i++) {
> > +               if (pxm_to_node(i) == NUMA_NO_NODE)
> > +                       continue;
> > +               for (j = 0; j < slit->locality_count; j++) {
> > +                       if (pxm_to_node(j) == NUMA_NO_NODE)
> > +                               continue;
> >                         numa_set_distance(pxm_to_node(i), pxm_to_node(j),
> >                                 slit->entry[slit->locality_count * i + j]);
> > +               }
> > +       }
> >  }
> >
> >  /* Callback for Proximity Domain -> x2APIC mapping */
> 
> wonder if the patch that i sent one year ago is better.
> 
> https://lkml.org/lkml/2013/1/21/559
> 
> as it avoid calling extra calling of pxm_to_node(i).

Your version looks good to me, although I do not believe the difference
is visible.  I will reply to your patch with one comment and ack.

Thanks,
-Toshi

