Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3IYNKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:10:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3IYNKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:10:36 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-01-5242e0ca304c
Date: Wed, 25 Sep 2013 15:10:22 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework to
 set APLL clock rate
Message-id: <20130925151022.74df54a7@amdc308.digital.local>
In-reply-to: <CAK9yfHzb8VA+E38iQ3b31Yjfd9BvKcEMBc_gijJ3hERa_fBqFw@mail.gmail.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
 <CAK9yfHzb8VA+E38iQ3b31Yjfd9BvKcEMBc_gijJ3hERa_fBqFw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xoO6pB05BBrtPalpsnLGe1aJ3wVU2
	i/7Hr5kt3jzitri8aw6bxefeI4wWM87vY7K43bgCKLmwl8ni5J9eRov1M16zWGz86uHA47Fp
	VSebx51re9g81k17y+zRt2UVo8ejxS2MHp83yQWwRXHZpKTmZJalFunbJXBlbPi+kq2giafi
	w89fzA2MXzm6GDk5JARMJDpP9DNC2GISF+6tZ+ti5OIQEpjOKHGzaz0ThNPOJHF14Q4WkCoW
	AVWJjjktzCA2m4CexOe7T5lAbBEBLYmX3cvBGpgFrjJLLHz8nL2LkYNDWCBVontmCkgNr4C1
	xJq/k8F6OQWCJf7uOsIKseAUo8ScP5fAzuAXkJRo//eDGeIkO4lznzawQzQLSvyYfA/sCGag
	ZZu3NbFC2PISm9e8ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7
	iREcOc+kdzCuarA4xCjAwajEwytw1DFIiDWxrLgy9xCjBAezkghv/3WnICHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2M9mZlUTo7Xuhe3yXSu26Htd+X
	OWvDGRa/neD2RlZeOf26SumDWYd+cAtHWhwye5YbUSzw7d4Rx2uLFl9wavPkt396+crHkltS
	t8Taz+uevCpy79mhJXwZ4iYevt2encK/4s5FbC+KkmO+Ur6nrSZ7jdXTkwrdWySmvGGY09Q2
	X9rSvMRT2rJWiaU4I9FQi7moOBEAjNz9rpgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

> Hi Lukasz,
> 
> On 25 September 2013 16:52, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> >
> >  static void exynos4x12_set_apll(unsigned int index)
> >  {
> > -       unsigned int tmp, pdiv;
> > +       unsigned int tmp, freq = apll_freq_4x12[index].freq;
> 
> nit: It is better to put the 'freq' assignment on a new line.

checkpatch.pl wasn't complaining :-).
Also please consider below comment.

> 
> >
> > -       /* 1. MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
> > +       /* MUX_CORE_SEL = MPLL, ARMCLK uses MPLL for lock time */
> >         clk_set_parent(moutcore, mout_mpll);
> >
> >         do {
> > @@ -140,24 +140,9 @@ static void exynos4x12_set_apll(unsigned int
> > index) tmp &= 0x7;
> >         } while (tmp != 0x2);
> >
> > -       /* 2. Set APLL Lock time */
> > -       pdiv = ((apll_freq_4x12[index].mps >> 8) & 0x3f);
> > +       clk_set_rate(mout_apll, freq * 1000);
> 
> Don't we need to check the return value of this?

The broken code isn't handling errors now (*_set_apll() function is
defined as void). Since this patch is a regression fix (for v3.12) I
just wanted to change as little as possible to provide a functional fix.

I think that regression fix shall not change much functionality -
therefore the exynosXXXX-cpufreq.c cleanup will be done for next kernel
release.

> 
> Same comments for the second patch too.
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
