Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaGIMmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:42:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57041 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932094AbaGIMm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:42:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ACPI/Wakup: Enable button wakeup GPEs if these GPEs have associated GPE methods.
Date: Wed, 09 Jul 2014 15:00:32 +0200
Message-ID: <1566864.H9h1bMoShf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53BCB23A.1070304@intel.com>
References: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com> <3011365.oYtXFx0LHa@vostro.rjw.lan> <53BCB23A.1070304@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 11:08:42 AM Lan Tianyu wrote:
> On 2014年07月08日 21:26, Rafael J. Wysocki wrote:
> > On Tuesday, July 08, 2014 02:57:58 PM Lan Tianyu wrote:
> >> The button wakeup GPEs are enabled unconditionally in the current world by
> >> commit 2a5d24(ACPI / Wakeup: Enable button GPEs unconditionally during
> >> initialization). Because button's GPE methods needs to be run to clear
> >> GPE status on some machines when there is GPE interrupt. If not, it will
> >> cause machines resume immediately after being suspended since GPE status
> >> isn't cleared correctly.
> >>
> >> But if there is no GPE method for button wakeup GPE, these GPEs should not
> >> be enabled since nothing needs to be done when they are triggered and this
> >> also causes LID GPE storm on Lenovo Ideapad y560p.
> >>
> >> This patch is to check Button GPE method and enable it if there is associated
> >> GPE method.
> > 
> > Part of the problem is that we call acpi_setup_gpe_for_wake() for buttons too
> > and it sets ACPI_GPE_DISPATCH_NOTIFY unconditionally.
> 
> Yes, this is why the GPE wasn't disabled by CA. From my opinion,
> original reason of enabling button wakeup GPE in the runtime is that it
> may have associated GPE method and the method will notify button driver
> and clear some hardware status. But if it didn't have GPE method, I
> don't why we need to enable the GPE.

I think you're right, but "is there a handler method for that GPE present?"
is a bit too low-level question to ask from outside of ACPICA.  We should be
asking "is there any kind of handling registered for it?" if anything, but in
my opinion the cleanest approach would be to modify acpi_enable_gpe() to
return an error code if there's no handler/method/notify for the GPE in
question.

The patch I attached to the BZ entry doesn't do that just yet, because I'm
wondering whether or not it will make the ACPICA's auto-disabling trigger. :-)

Rafael

