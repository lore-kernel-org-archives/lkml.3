Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEWVuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:50:44 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:36798 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEWVum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <1400808739.19982.48.camel@debian>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	<537C040E.3040901@jp.fujitsu.com>
	<1400637782.14703.32.camel@debian>
	<537C12BC.6080408@jp.fujitsu.com>
	<1400642398.14703.42.camel@debian>
	<537C1F24.8000604@jp.fujitsu.com>
	<3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
	<1400808739.19982.48.camel@debian>
Date: Fri, 23 May 2014 14:50:41 -0700
Message-ID: <CA+8MBbK0XfSDcef6vHEy+CSs-2xJvNpPD5wnHjAE=uOzE7eP3g@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
From: Tony Luck <tony.luck@gmail.com>
To: Chen Yucong <slaoub@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 6:32 PM, Chen Yucong <slaoub@gmail.com> wrote:
> As Naoya Horiguchi says, this patch also have a small benefit that it
> can reduce the processing time of monarch CPU.

This is indeed a benefit - but I'm not super worried about performance
of machine check handler.

>        /*
>         * Now clear the mces_seen of current CPU -*final - so that it
> does not
>         * reappear on the next mce.
>         */
>        memset(final, 0, sizeof(struct mce));
>        mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);

But if the monarch hasn't managed to clean mces_seen, then
it certainly hasn't cleared MCG_STATUS ... so there can't be
a "next" mce that would see these old values. Any extra MCE
will result in system reset.

So we are not arguing that your patch is wrong - it just doesn't seem
to be any better that what we have now (except for an unimportant
small performance improvement).

-Tony
