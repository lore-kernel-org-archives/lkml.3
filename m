Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3GPJjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:39:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58799 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3GPJjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:39:35 -0400
X-AuditID: cbfee61b-b7f1f6d000000f14-f3-51e514d56a91
Date: Tue, 16 Jul 2013 11:39:24 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "l.majewski@majess.pl" <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 1/7] cpufreq: Store cpufreq policies in a list
Message-id: <20130716113924.46f40467@amdc308.digital.local>
In-reply-to: <CAKohponOEcwq4eAjwxHMM6puuqGmtJ4GpqqRHyEqvhXM+Yt6wQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-2-git-send-email-l.majewski@samsung.com>
 <CAKohponOEcwq4eAjwxHMM6puuqGmtJ4GpqqRHyEqvhXM+Yt6wQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgO5VkaeBBg+uaFn8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52MdmsfGr
	hwOvx+I9L5k87lzbw+axbtpbZo++LasYPR4tbmH0OH5jO5PH501yAexRXDYpqTmZZalF+nYJ
	XBlHe9tZC+ZyVMzvWsfawHiDrYuRg0NCwERi1szCLkZOIFNM4sK99UBhLg4hgUWMEj8nf2cH
	SQgJtDNJTPpRDWKzCKhKHGvZxgJiswnoSXy++5QJZI6IgJbEy5upIL3MAj0sEoeubGcDqREW
	cJU49ewZmM0rYC0xdXUDM0g9p0CwROd8H4jxLUwSf6Ywg9j8ApIS7f9+MEPcYydx7tMGdohW
	QYkfk++BrWUGWrV5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBMfRMegfjqgaLQ4wCHIxKPLwHOZ8ECrEmlhVX5h5ilOBgVhLhvcX/NFCI
	NyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDo87f3HWff3oy
	bthXIV5rHxgkf9Cg775HcaFeuPXviIa7B9NfF1qs+y2uu0Lvj8y8drGdxz2lq6qe/uFY0vPm
	r9uuw6HXpsQEZK/N335x/r+bQh5n/v/e325w9IERp5GU+I9kxeTK/g2xPcnf9hyNDnn85Viv
	1pTyhVWeHk9yGb/Wxa+NE1g/Q4mlOCPRUIu5qDgRADe/quedAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 10:51:27 +0200 Viresh Kumar wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
> > @@ -2056,6 +2058,7 @@ int cpufreq_unregister_driver(struct
> > cpufreq_driver *driver)
> > subsys_interface_unregister(&cpufreq_interface);
> > unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
> >
> > +       list_del(&cpufreq_policy_list);
> 
> You can't delete the list this way... You must have passed the list
> entry you wanted to delete. More precisely link from the struct
> cpufreq_policy.

Yes. I shouldn't delete statically defined head of the list. Thanks for
spotting.

> 
> Over that, it shouldn't be done at the time of unregistering cpufreq
> driver but as and when cpus are removed and _cpu_remove_dev
> is called.

OK, I will iterate the list at __cpufreq_remove_dev() and remove each
of them there.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
