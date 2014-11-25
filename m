Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaKYPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:21:12 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36644 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKYPVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:21:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141125151515.GG2361@bivouac.eciton.net>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141125145854.A46EDC44343@trevor.secretlab.ca> <20141125151515.GG2361@bivouac.eciton.net>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 25 Nov 2014 15:20:49 +0000
X-Google-Sender-Auth: voAoD6mhQEdTif3H8p_vG8keskQ
Message-ID: <CACxGe6v2i3iJGjK9s6HSBxV6bUwVrAtGYj=FAOb0AFEx3KVYEg@mail.gmail.com>
Subject: Re: [PATCH] of: support passing console options with stdout-path
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        ijc@debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 3:15 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Tue, Nov 25, 2014 at 02:58:54PM +0000, Grant Likely wrote:
>> > +           len = strchrnul(path, ':') - path;
>> > +
>> >             for_each_property_of_node(of_aliases, pp) {
>> >                     if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
>> >                             np = of_find_node_by_path(pp->value);
>>
>> Can you add a testcase to drivers/of/unittests.c for this new path
>> parsing? Then we know it's correct!
>
> Will do.
>
>> > @@ -1830,8 +1835,12 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>> >                     name = of_get_property(of_chosen, "linux,stdout-path", NULL);
>> >             if (IS_ENABLED(CONFIG_PPC) && !name)
>> >                     name = of_get_property(of_aliases, "stdout", NULL);
>> > -           if (name)
>> > +           if (name) {
>> >                     of_stdout = of_find_node_by_path(name);
>> > +                   of_stdout_options = strchr(name, ':');
>> > +                   if (of_stdout_options != NULL)
>> > +                           of_stdout_options++;
>> > +           }
>>
>> Not so good. The ':' should actually be a generic part of
>> of_find_node_by_path(), it doesn't have to be limited to stdout parsing.
>> There are other places that would use it. I would add a second,
>> optional, argument to of_find_node_by_path() that will update a pointer
>> to the arguments after the ':'.
>
> So, I agree this would be nicer...
>
> However, I'm counting 157 callers of this function outside of
> drivers/of and 43 inside. Any chance you'd let me get away with a
> separate of_find_extra_options_by_path()?

I'd rather not. It is a trivial change and can be pretty much done
mechanically. Something like (I think; I always have to look up the
sed syntax):

sed s/of_find_node_by_path\((.*)\)/of_find_node_by_path\(\1, NULL\)

If it turns out to be really painful, then I'll relent, but I'd like
you to at least try! :-)

g.
