Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3H2RzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:55:15 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:43156 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3H2RzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:55:13 -0400
Date: Thu, 29 Aug 2013 19:55:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yang, Fei" <fei.yang@intel.com>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Can anyone suggest a better fix? Not sure if I understand the
	problem, but the patch fixed it
Message-ID: <20130829175511.GA23620@merkur.ravnborg.org>
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com> <20130826201035.GA21141@merkur.ravnborg.org> <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com> <521E1232.6010501@suse.cz> <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I thought fixdep is about finding module dependency, and
> it isn't needed for built-in drivers.
> Please correct me if I'm wrong.

You are wrong...

Fixdep conatins all the dependencies used to determine if we shall rebuild foo.o.
It has nothing to do with modules or not.

Following happens when you build foo.o from foo.c:

1) gcc -Wp,-MD,foo.o.d  foo.c -o foo.o
This produces two files:
foo.o.d - contains all files included by foo.c, recursive (try it out!)
foo.o - the object file

2) fixdep foo.o.d foo.o gcc -Wp,-MD,foo.o.d  foo.c -o foo.o > foo.o.tmp
fixdep now does the following:
- Assign the comandline to a variable
- List all dependencies (files included)
   - Scan the dependen file for CONFIG_* symbols
      - for each CONFIG_* symbol add a $(wildcard ...) reference to a symbol in
        include/generated/config/... that represents the CONFIG_ symbol
Everything is stored in foo.o.tmp

3) delete foo.o.cmd
4) rename foo.o.tmp to foo.o.cmd


Magic happens in Kbuild.include, Makefile.lib and Makefile.build.
But it make take some cup of coffee to grasp it.

For find and fix whatever race condition you hit.

	Sam
