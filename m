Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3F0QyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:54:14 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:39794 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0QyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:54:13 -0400
MIME-Version: 1.0
From: Tim Hockin <thockin@hockin.org>
Date: Thu, 27 Jun 2013 09:53:52 -0700
X-Google-Sender-Auth: IiKu4gQ2wx3LWez_kuzrP3jHr60
Message-ID: <CAAAKZwuKxxYoVRn6Ye72Vs7vSd_T4cbvEwiU6Q3j4D-Z+VAPrw@mail.gmail.com>
Subject: cgroup access daemon
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the subject, so as not to mix two discussions

On Thu, Jun 27, 2013 at 9:18 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>
>> > FWIW, the code is too embarassing yet to see daylight, but I'm playing
>> > with a very lowlevel cgroup manager which supports nesting itself.
>> > Access in this POC is low-level ("set freezer.state to THAWED for cgroup
>> > /c1/c2", "Create /c3"), but the key feature is that it can run in two
>> > modes - native mode in which it uses cgroupfs, and child mode where it
>> > talks to a parent manager to make the changes.
>>
>> In this world, are users able to read cgroup files, or do they have to
>> go through a central agent, too?
>
> The agent won't itself do anything to stop access through cgroupfs, but
> the idea would be that cgroupfs would only be mounted in the agent's
> mntns.  My hope would be that the libcgroup commands (like cgexec,
> cgcreate, etc) would know to talk to the agent when possible, and users
> would use those.

For our use case this is a huge problem.  We have people who access
cgroup files in a fairly tight loops, polling for information.  We
have literally hundeds of jobs running on sub-second frequencies -
plumbing all of that through a daemon is going to be a disaster.
Either your daemon becomes a bottleneck, or we have to build something
far more scalable than you really want to.  Not to mention the
inefficiency of inserting a layer.

We also need the ability to set up eventfds for users or to let them
poll() on the socket from this daemon.

>> > So then the idea would be that userspace (like libvirt and lxc) would
>> > talk over /dev/cgroup to its manager.  Userspace inside a container
>> > (which can't actually mount cgroups itself) would talk to its own
>> > manager which is talking over a passed-in socket to the host manager,
>> > which in turn runs natively (uses cgroupfs, and nests "create /c1" under
>> > the requestor's cgroup).
>>
>> How do you handle updates of this agent?  Suppose I have hundreds of
>> running containers, and I want to release a new version of the cgroupd
>> ?
>
> This may change (which is part of what I want to investigate with some
> POC), but right now I'm building any controller-aware smarts into it.  I
> think that's what you're asking about?  The agent doesn't do "slices"
> etc.  This may turn out to be insufficient, we'll see.

No, what I am asking is a release-engineering problem.  Suppose we
need to roll out a new version of this daemon (some new feature or a
bug or something).  We have hundreds of these "child" agents running
in the job containers.

How do I bring down all these children, and then bring them back up on
a new version in a way that does not disrupt user jobs (much)?

Similarly, what happens when one of these child agents crashes?  Does
someone restart it?  Do user jobs just stop working?

>
> So the only state which the agent stores is a list of cgroup mounts (if
> in native mode) or an open socket to the parent (if in child mode), and a
> list of connected children sockets.
>
> HUPping the agent will cause it to reload the cgroupfs mounts (in case
> you've mounted a new controller, living in "the old world" :).  If you
> just kill it and start a new one, it shouldn't matter.
>
>> (note: inquiries about the implementation do not denote acceptance of
>> the model :)
>
> To put it another way, the problem I'm solving (for now) is not the "I
> want a daemon to ensure that requested guarantees are correctly
> implemented." In that sense I'm maintaining the status quo, i.e. the
> admin needs to architect the layout correctly.
>
> The problem I'm solving is really that I want containers to be able to
> handle cgroups even if they can't mount cgroupfs, and I want all
> userspace to be able to behave the same whether they are in a container
> or not.
>
> This isn't meant as a poke in the eye of anyone who wants to address the
> other problem.  If it turns out that we (meaning "the community of
> cgroup users") really want such an agent, then we can add that.  I'm not
> convinced.
>
> What would probably be a better design, then, would be that the agent
> I'm working on can plug into a resource allocation agent.  Or, I
> suppose, the other way around.
>
>> > At some point (probably soon) we might want to talk about a standard API
>> > for these things.  However I think it will have to come in the form of
>> > a standard library, which knows to either send requests over dbus to
>> > systemd, or over /dev/cgroup sock to the manager.
>> >
>> > -serge
