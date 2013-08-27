Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3H0LQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:16:40 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57948 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3H0LQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:16:38 -0400
Date: Tue, 27 Aug 2013 13:16:27 +0200
From: Robert Richter <rric@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 08/12] perf, persistent: Exposing persistent events
 using sysfs
Message-ID: <20130827111627.GC15884@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-9-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221344500.26486@pianoman.cluster.toy>
 <20130823093708.GA10223@rric.localhost>
 <alpine.DEB.2.02.1308231227180.7482@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308231227180.7482@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.13 12:39:53, Vince Weaver wrote:
> On Fri, 23 Aug 2013, Robert Richter wrote:
> Make no assumptions when documenting.  When I as a user have to dig around
> the kernel source tree to find out what is going on then the documentation 
> is lacking.
> 
> > > Is this endian clean?  Will attr5:23 point to the same bit on a big-endian 
> > > machine as on little-endian?
> > 
> > It is the endianness used in the syscall. Handled in the same way as
> > for the config fields. I don't see where this could be an issue.
> 
> C bitfields go opposite ways on big-endian vs little-endian systems.
> This has come up with some of the bitfields in the sample buffers.
> It doesn't matter if you just use the bitfields, but if you're trying
> to poke single bits into opaque 64-bit blobs it might be an issue.

Ok, let's improve documentation, how about the patch below?

> > The format directories in /sys/bus/event_source/devices/*/format/ are
> > already there to make it human readable. A user never has to deal
> > directly with syntax provided there and may use already the
> > abstractions for the event syntax.
> 
> The format directory for now was only for the "config" fields which
> traditionally were needed to specify an event, that is all.
> 
> Things get a lot more complex if arbitrary subsets of the the perf_attr
> structure start getting exported.

I don't see anything special with config fields, why not expand the
same functionality to other fields in perf_attr too? Your example for
precise_ip shows this could be useful.

And again, a while ago there was the decision to use sysfs to specify
events (I didn't like the approach too). Now, we must be able to setup
*any* kind of event in that way, not just that ones that can be setup
only by using config fields.

> > The problem with this is that you have to implement this in the event
> > parser of perf tools. Thus, you need to update the parser for any
> > other syntax you want to use. This is not necessary with my
> > implementation. It already provides the above. The pmu driver just
> > need to add the sysfs entry.
> 
> I see.  Are you going to update the parsers for programs that
> also try to read these values, like trinity?  
> 
> Or is the perf tool special because it is in the kernel?

First of all, the change is backward compatible for any tool out. If
not implemented, the parser throws an error and the event with the new
format can not be setup via sysfs. If other tools do not use such
events, no need to update anything.

The event parser became a bit complex already, thus it might be useful
to split the code and put it in some library e.g. liblk or so. There
are plans to do this.

-Robert



diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 77f47ff..d8f348f 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -1,20 +1,50 @@
-Where:		/sys/bus/event_source/devices/<dev>/format
+Where:		/sys/bus/event_source/devices/<pmu>/format/<name>
 Date:		January 2012
-Kernel Version: 3.3
+Kernel Version:	3.3
+		3.xx	(added attr<index>:<bits>)
 Contact:	Jiri Olsa <jolsa@redhat.com>
-Description:
-		Attribute group to describe the magic bits that go into
-		perf_event_attr::config[012] for a particular pmu.
-		Each attribute of this group defines the 'hardware' bitmask
-		we want to export, so that userspace can deal with sane
-		name/value pairs.
-
-		Userspace must be prepared for the possibility that attributes
+
+Description:	Define formats for bit ranges in perf_event_attr
+
+		Specify a format to describe the magic bits that go
+		into struct perf_event_attr for a particular pmu.
+		Userspace can deal then with sane name/value pairs.
+
+		Bit range may be any bit mask of an u64 value (bits 0
+		to 63). The bit range may vary depending on the
+		system's endianess if the underlying field is an u32,
+		for example the format is for bp_type:
+
+			attr7:32-63 ... little endian
+			attr7:0-31  ... big endian
+
+		Userspace must be prepared for the possibility that formats
 		define overlapping bit ranges. For example:
-			attr1 = 'config:0-23'
-			attr2 = 'config:0-7'
-			attr3 = 'config:12-35'
 
-		Example: 'config1:1,6-10,44'
-		Defines contents of attribute that occupies bits 1,6-10,44 of
-		perf_event_attr::config1.
+			format1 = 'config:0-23'
+			format2 = 'config:0-7'
+			format3 = 'config:12-35'
+
+		Syntax			Description
+
+		config[012]*:<bits>.... Format that defines any
+					'hardware' bitmask in one of
+					the config fields.
+
+		attr<index>:<bits>..... Format that defines any
+					bitmask in any u64 field in
+					the perf_event_attr structure.
+					The index is a decimal number
+					specifying the u64 value to be
+					pointed to in perf_event_attr.
+					Index starts at zero.
+
+		Examples:
+
+		'config1:1,6-10,44'	Defines contents of attribute
+					that occupies bits 1,6-10,44
+					of perf_event_attr::config1.
+
+		'attr5:23'		Define the persistent event
+					flag (bit 23 of the attribute
+					flags)
