Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182AbaCOBnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:43:39 -0400
Received: from nm3.bullet.mail.gq1.yahoo.com ([98.136.218.68]:34696 "EHLO
	nm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbaCOBni convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:43:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 849103.57125.bm@omp1018.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rkzGKHuftEwAu/NIjWyHlAb/YS3fFT8d5d1Gd/3Sb7/7IjYbLTzDsROumJTalHzkTN2kDrRLMt5muWbzJLqXsDGtDKSlgav+blWxA/9gQXeKCZ8inuUszlC//L5AnQuyOraxa7ZzonNTPw0ix72NXi0N3+yKm+uZhk2mpCegedY=;
X-YMail-OSG: KXFhn8IVM1nZtUjLhRDsR5bKzEetmgmUmItl.GaVWIXhiAJ
 DCtUm8G6PgfrpvEUxhApvitVOb_8vujIVY.fjkEbx5zsM_d9W62McZqB_tVa
 ohc34eLLpSlyfay.WYRhE9RQCl68GNeLo7z2M_faiImtFN8HND3htuIZkQ6.
 lPXPpvCn.HgeEk4d_Au.D.lXsJgFn7M_jR8YuKq3lmYYFPJo09UjoDr.n6tN
 viaYAZXVvQzg4dB0zN59CPw6TvHKepxeWryA_qVMXjTZ7qCPdrekPxIyCwk9
 l2sYAAlRBs7O4as1mzWSjEBo9n0Rmpfj2kXc9RlwP9cs3VeihHuZwrK.2p9Q
 vmdZ2_f0hyvjFg.TeADWrW.EJkQfguq81xoPKjr._NqwQszkgwabCylzCXCG
 0pABHSLLvytrU1WPt5FR2I8qu_2KR6KjaEixfb1Mz6_gX0rW0ZKH91fjZ4JH
 0a0XtJoIE3Gqt7a6GgP.Gh2jLefKJDUxEYQiwb35mXz4tbun_3S7a_2MgOd.
 6nzbyszLO05U0lNoU0YPKR31s0w--
X-Rocket-MIMEInfo: 002.001,Pk9uIFR1ZXNkYXksIE1hcmNoIDExLCAyMDE0IDk6MjYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKCj4.T24gMjAxNC0wMy0wOSAwNDowMCwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.PiBUaGlzIHBhdGNoIGNoYW5nZXMgYSBoYW5kZnVsIG9mIHdoaWxlIGxvb3BzIHRvIHRpbWVvdXRzIHRvIHByZXZlbnQKPj4gaW5maW5pdGUgbG9vcGluZyBvbiBoYXJkd2FyZSBmYWlsdXJlLiBBIGNvdXBsZSBzdWNoIGxvb3BzIGFyZSBpbiBhCj4.IGZ1bmN0aW9uIChzNjI2X2RlYmlfdHJhbnMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <20140309030056.GA10867@kroah.com> <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com> <531F1D18.4060109@mev.co.uk>
Message-ID: <1394847817.37014.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Fri, 14 Mar 2014 18:43:37 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts in s626.c
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
In-Reply-To: <531F1D18.4060109@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tuesday, March 11, 2014 9:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-03-09 04:00, Chase Southwood wrote:
>> This patch changes a handful of while loops to timeouts to prevent
>> infinite looping on hardware failure. A couple such loops are in a
>> function (s626_debi_transfer()) which is called from critical sections,
>> so comedi_timeout() is unusable for them, and an iterative timeout is
>> used instead. For the while loops in a context where comedi_timeout() is
>> allowed, a new callback function, s626_send_dac_eoc(), has been defined
>> to evaluate the conditions that the while loops are testing.  The new
>> callback employs a switch statement based on a simple new enum so that
>> it is usable for all of the different conditions tested in while loops
>> in s626_send_dac().  The proper comedi_timeout() calls are then used.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> Ian, here is a version of this patchset employing the enum you recommended.
>> The second patch has been rebased on top of this one.
>>
>> 2: Used comedi_timeout() where appropriate, introduce callback function
>>
>> 3: Updated callback to switch on new enum.>
>
>Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>
>For future reference, for patches affecting a single comedi driver, we 
>usually title the patches like this:
>
>staging: comedi: name_of_driver: summary of patch
>


Hi Greg!

I was just writing to inquire whether you were able to add this patch as well as
PATCH 2/2 Propagate timeout errors in s626.c, to your queue in their current state.
I had to resend this patch to you about a week ago because the subject line got
a little messed up, which might have lead to a bit of confusion regarding the 2
patch series, and I wanted to check in to see whether you need me to do anything
further.

Thanks,
Chase
