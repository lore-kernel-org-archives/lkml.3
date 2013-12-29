Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3L2Ouk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 09:50:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63600 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751681Ab3L2Oui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 09:50:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kashyap Chamarthy <kchamart@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Date: Sun, 29 Dec 2013 16:04:12 +0100
Message-ID: <4794554.Hmd2RUNYDT@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52C011A2.3040800@redhat.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <231382870.yshsPRR4KM@vostro.rjw.lan> <52C011A2.3040800@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 29, 2013 01:12:18 PM Kashyap Chamarthy wrote:
> [. . .]
> 
> >> Here's host dmesg: https://bugzilla.kernel.org/attachment.cgi?id=119751
> >>
> >>>> Can you ftrace the failure?
> >>
> >> Can try, need some time (rest of the day I'll be away travelling,
> >> will try to do it over the weekend, and update the Kernel
> >> bugzilla with observations).
> >>
> >>>>
> >>> Ugh, it looks like guest dmesg but there are KVM messages there too ("[
> >>> 281.443662] kvm [2452]: vcpu0 unhandled rdmsr: 0xe8" is unhandled access
> >>> to MSR_IA32_APERF I was talking about above), so I guess this is nested
> >>> guest invocation? 
> >>
> >> Yeah -- sorry, I forgot to note it's in a nested environment :(
> >>
> >>> Does it happen in non nested guest?
> >>
> >> I need to that.
> >>
> >> Note to self: Also try with a newer Kernel on the host.
> > 
> > Please try the patch I posted earlier today when you're at it:
> > 
> > https://patchwork.kernel.org/patch/3411991/
> 
> I applied the patch & tried to build the Kernel, it failed with:
> 
> =======
> .
> .
> .
> Generating a 4096 bit RSA private key
> ............................................................................................................drivers/cpufreq/intel_pstate.c:
> In function 'intel_pstate_init_cpu':
> drivers/cpufreq/intel_pstate.c:617:18: error: 'struct pstate_data' has no member named
> 'current_state'
>   if (!cpu->pstate.current_state) {

My bad, that should have been current_pstate.  Updated patch is appended.

Thanks,
Rafael


---
 drivers/cpufreq/intel_pstate.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-pm/drivers/cpufreq/intel_pstate.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/intel_pstate.c
+++ linux-pm/drivers/cpufreq/intel_pstate.c
@@ -614,6 +614,11 @@ static int intel_pstate_init_cpu(unsigne
 	cpu = all_cpu_data[cpunum];
 
 	intel_pstate_get_cpu_pstates(cpu);
+	if (!cpu->pstate.current_pstate) {
+		all_cpu_data[cpunum] = NULL;
+		kfree(cpu);
+		return -ENODATA;
+	}
 
 	cpu->cpu = cpunum;
 

