Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965474Ab3FTLfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:35:17 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48847 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965457Ab3FTLe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:34:57 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] perf tools: Make Power7 events available for perf
Date: Thu, 20 Jun 2013 11:57:15 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B729C@saturn3.aculab.com>
In-Reply-To: <1371692489.21846.14.camel@concordia>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] perf tools: Make Power7 events available for perf
Thread-Index: Ac5tV1q6Yo+sY0F1TViNHfGNk0/AfQATPsVw
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com> <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com> <1371692489.21846.14.camel@concordia>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Michael Ellerman" <michael@ellerman.id.au>,
        "Runzhen Wang" <runzhen@linux.vnet.ibm.com>
Cc: <icycoder@gmail.com>, <linux-kernel@vger.kernel.org>,
        <xiaoguangrong@linux.vnet.ibm.com>, <acme@redhat.com>,
        <paulus@samba.org>, <sukadev@linux.vnet.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we should be able to do something better using the C
> preprocessor, this is exactly the sort of thing it's good at.
> 
> What I mean is something like we do with arch/powerpc/include/asm/systbl.h,
> where we define the list of syscalls once, and then include it in
> multiple places, using different macro definitions to get different
> outputs.

There is a 'neat' trick - you can pass a #define macro the
name of another #define - which is then expanded after the
initial expansion. A description I happen to have is pasted below.

	David

Consider what happens when #define foo(x) x(args) is expanded: foo(bar)
clearly becomes bar(args). If we also have #define bar(args) then bar()
is expanded AFTER foo() allowing us to generate any text including args.
So we have passed the name of one #define as a parameter to a different #define.

If we replace the definition of foo with
#define foo(x) x(args1) x(args2) then foo(bar) is equivalent to
bar(args1) bar(args2).
This is useful because foo(baz) expands to baz(args1) baz(args2)
allowing us to feed the same set of arguments to more than one #define.

A simple example:
	#define lights(x) x(red) x(orange) x(green)
	#define xx(colour) LIGHT_##colour,
	enum { lights(xx) NUM_LIGHTS };
	#undef xx
	#define xx(colour) #colour,
	static const char light_names[] = { lights(xx) };
	#undef xx

This expands to:
	enum { LIGHT_red, LIGHT_orange, LIGHT_green, NUM_LIGHTS };
	static const char light_names[] = { ”red”, ”orange”, ”green”, };
(We needed to add NUM_LIGHTS because a trailing comma isn’t valid in a C++ enum.)


