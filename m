Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaI3Dlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:41:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaI3Dlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:41:50 -0400
Date: Mon, 29 Sep 2014 23:41:29 -0400
From: Dave Jones <davej@redhat.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Bugfix bit-rot in the calling of
 legacy_cache_size
Message-ID: <20140930034129.GB14558@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bryan O'Donoghue <pure.logic@nexus-software.ie>, mingo@redhat.com,
	hpa@zytor.com, tglx@linutronix.de, hmh@hmh.eng.br, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
 <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 04:11:48AM +0100, Bryan O'Donoghue wrote:

 > Make an update to identify_cpu to make an explicit call to default_init()
 > We want to do this since some processors that report vendor strings via
 > cpuid also want to run legacy_cache_size callbacks - which won't happen
 > since init_intel() init_amd() and friends take the place of default_init()
 > and don't themselves make explicit calls to legacy_cache_size.
 > 
 > Also current code has an
 > #ifdef CONFIG_X86_64
 >         cpu_detect_cache_sizes(c);
 > #endif

...

 >  static void default_init(struct cpuinfo_x86 *c)
 >  {
 > -#ifdef CONFIG_X86_64
 >  	cpu_detect_cache_sizes(c);
 > -#else
 > +
 >  	/* Not much we can do here... */
 >  	/* Check if at least it has cpuid */
 >  	if (c->cpuid_level == -1) {
 > @@ -79,7 +78,6 @@ static void default_init(struct cpuinfo_x86 *c)
 >  		else if (c->x86 == 3)
 >  			strcpy(c->x86_model_id, "386");
 >  	}
 > -#endif

Shouldn't this patch be more like..

-#ifdef CONFIG_X86_64
  	cpu_detect_cache_sizes(c);
-#else
+
+#ifdef CONFIG_X86_32

 ?

The 386/486 stuff in this codepath isn't huge, but it
seems pointless to be compiling it on 64-bit.

	Dave

