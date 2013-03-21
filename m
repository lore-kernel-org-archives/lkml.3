Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3CUBjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:39:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37346 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CUBjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <1363820491.6345.21.camel@gandalf.local.home>
References: <1363749497-12176-1-git-send-email-kpark3469@gmail.com>
	<1363800712.6345.17.camel@gandalf.local.home>
	<20130320180113.GA24537@Krystal>
	<1363820491.6345.21.camel@gandalf.local.home>
Date: Thu, 21 Mar 2013 10:39:21 +0900
Message-ID: <CA+KhAHaWT5FR5J8iBr_DExrNTBC50LyEo8NG-qZbF6NPEy+zFA@mail.gmail.com>
Subject: Re: [PATCH] tracepoints: prevents null probe from being added
From: Keun-O Park <kpark3469@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        keun-o.park@windriver.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 8:01 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2013-03-20 at 14:01 -0400, Mathieu Desnoyers wrote:
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>> > On Wed, 2013-03-20 at 12:18 +0900, kpark3469@gmail.com wrote:
>> > > From: Sahara <keun-o.park@windriver.com>
>> > >
>> > > Somehow tracepoint_entry_add/remove_probe functions allow a null probe
>> > > function.
>> >
>> > You actually hit this in practice, or is this just something that you
>> > observe from code review?
>> >
>> > >  Especially on getting a null probe in remove function, it seems
>> > > to be used to remove all probe functions in the entry.
>> >
>> > Hmm, that actually sounds like a feature.
>>
>> Yep. It's been a long time since I wrote this code, but the removal code
>> seems to use NULL probe pointer to remove all probes for a given
>> tracepoint.
>>
>> I'd be tempted to just validate non-NULL probe within
>> tracepoint_entry_add_probe() and let other sites as is, just in case
>> anyone would be using this feature.
>>
>> I cannot say that I have personally used this "remove all" feature much
>> though.
>>
>
> I agree. I don't see anything wrong in leaving the null probe feature in
> the removal code. But updating the add code looks like a proper change.
>
> -- Steve
>
>

Hello Steve & Mathieu,
If we want to leave the null probe feature enabled, I think it would
be better modifying the code like the following for code efficiency.

@@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
        int nr_probes = 0;
        struct tracepoint_func *old, *new;

-       WARN_ON(!probe);
+       if (WARN_ON(!probe))
+               return ERR_PTR(-EINVAL);

        debug_print_probes(entry);
        old = entry->funcs;
@@ -152,14 +153,15 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *ent

        debug_print_probes(entry);
        /* (N -> M), (N > 1, M >= 0) probes */
-       for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-               if (!probe ||
-                   (old[nr_probes].func == probe &&
-                    old[nr_probes].data == data))
-                       nr_del++;
+       if (probe) {
+               for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+                       if (old[nr_probes].func == probe &&
+                            old[nr_probes].data == data)
+                               nr_del++;
+               }
        }

-       if (nr_probes - nr_del == 0) {
+       if (!probe || nr_probes - nr_del == 0) {
                /* N -> 0, (N > 1) */
                entry->funcs = NULL;
                entry->refcount = 0;

Because we know handing over the null probe to
tracepoint_entry_add_probe is not possible,
we don't have to check if the probe is null or not within for loop. If
the probe is null, it's just enough to add !probe in
'if(nr_probes-nr_del==0)'. And, with additional if-clause wrapping
for-loop, falling through for-loop can be prevented when probe is
null.

@@ -173,8 +172,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry
                if (new == NULL)
                        return ERR_PTR(-ENOMEM);
                for (i = 0; old[i].func; i++)
-                       if (probe &&
-                           (old[i].func != probe || old[i].data != data))
+                       if (old[i].func != probe || old[i].data != data)
                                new[j++] = old[i];
                new[nr_probes - nr_del].func = NULL;
                entry->refcount = nr_probes - nr_del;

We don't have to check the probe here too. We know probe is always true here.
Thanks.

-- Kpark
