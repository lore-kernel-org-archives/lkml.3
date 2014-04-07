Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaDGRK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:10:59 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64654 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbaDGRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:10:54 -0400
Message-ID: <1396890652.12738.21.camel@x220>
Subject: Re: Kconfig circular dependency question
From: Paul Bolle <pebolle@tiscali.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Apr 2014 19:10:52 +0200
In-Reply-To: <5341DA66.5070907@lwfinger.net>
References: <5341AFC7.1070001@lwfinger.net> <5341B999.3050206@infradead.org>
		 <1396817575.4886.23.camel@x220> <5341C22A.1050907@lwfinger.net>
	 <1396818854.7118.3.camel@x220> <5341DA66.5070907@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2014 17:10:52.0585 (UTC) FILETIME=[549E3990:01CF5284]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 17:51 -0500, Larry Finger wrote:
> No problem - it is attached. The problem I was trying to solve was reported by 
> the kbuild test robot. To get the driver r8723au, you will need the staging-next 
> tree.

0) I couldn't reproduce your error with this config file (and the
next-20140407 tree). But I could reproduce by cbobbling together a
single rudimentary Kconfig file with the six symbols mentioned in the
error you had copied. And then I could cut things down to this minimal
test case:
    $ cat Kconfig.recursive 
    # test with 'yes "" | make KBUILD_KCONFIG=Kconfig.recursive oldconfig'
    mainmenu "Recursive dependency test case"

    config DRIVER1
	bool "Driver 1"
	select SUBSYSTEM2
	depends on SUBSYSTEM1

    config DRIVER2
	bool "Driver 2"
	select SUBSYSTEM1
	depends on SUBSYSTEM2

    config SUBSYSTEM1
	bool "Subsystem 1"

    config SUBSYSTEM2
	bool "Subsystem 2"

1) This made zero sense, until I realized that "select" statements are
treated as reverse dependencies in the kconfig code. And if you look at
these two select statements as reverse dependencies than, yes, this is a
Kconfig with a recursive dependency.

2) But the fact is that I actually don't think of "select" statements as
reverse dependencies. And in the Kconfig files they are not used as
reverse dependencies. See, for example, all the
    select USB

statements in the tree. I think there are many similar uses of "select".

3) So I think it makes no sense to treat "select" relations as reverse
dependencies. But perhaps I am missing something here.


Paul Bolle

