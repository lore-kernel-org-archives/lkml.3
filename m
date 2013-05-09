Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3EIV3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:29:21 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59703 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3EIV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:29:19 -0400
MIME-Version: 1.0
From: asharif <asharif@chromium.org>
Date: Thu, 9 May 2013 14:28:56 -0700
X-Google-Sender-Auth: ruFEAiVPK5-pnoVgNd9mbGFL8Jw
Message-ID: <CACPJwcdSbudHymXiQdrHJA85KfXnyCc3t+5DeA1tD5JxFpgAag@mail.gmail.com>
Subject: [perf] Introducing Quipper, a C++ perf reader library
To: linux-kernel@vger.kernel.org
Cc: Simon Que <sque@chromium.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Background/Motivation

=====================


We are ChromeOS developers who wanted to analyze Chrome's performance
on various devices. We wanted to record perf events, analyze the perf
data, and use it to make the Chrome experience faster. We ended up
writing Quipper, a library that allows us to do more than what the
perf tool allows. This library is open source and we'd like to get
some LKML-developer traction with it.


Quipper, a perf reader library

==============================


We developed Quipper as an open source perf data parser [1] with the ability to:

a) Read both piped and non-piped perf data.

b) Store it internally.

c) Post-process it.

d) Write the post-processed data back into a perf data file.

e) Convert perf data into a protocol buffer (protobuf) [2] format.


We found Quipper useful in a number of cases:


1. Quipper can read in perf data, and output it in protobuf format
with high fidelity [3]. Using protobufs instead of raw perf data has
the following advantages:

a) The protobuf format is backward-compatible. Developers don't have
to worry about changes in perf data format between kernel versions.

b) The protobuf format is cross-endian.  Perf data in protobuf format
collected from a big-endian machine can be easily viewed on a
little-endian machine (e.g. PowerPC --> x86).

c) The protobuf library has a clean, well-documented API. The API can
be used from different languages (C++, Python, etc.) and can dump the
messages in human-readable format [4].

d) By using protobufs instead of opaque perf.data, certain policies
can be enforced. For example, when we upload ChromeOS perf data in
protobuf format, we remove strings from it to respect the user's
privacy settings.

e) Developers can change events on-the-fly in the protobuf data
structures and serialize them in a single function call. There is no
need to resize events as when they are stored in a flat data format.


2. Quipper can read in perf data, sort it by time, and list all
PERF_RECORD_SAMPLE events along with their attributes like:

a) shared object name.

b) offset from the beginning of the shared object.

c) pid, tid, call graph, branch stack and other associated data with the sample.

This API can then be used to write a custom symbolizer like `perf report`.


3. Quipper can iterate over all events and re-map all the addresses
into a synthetic address space. This is useful in a system where we
have all the following conditions:

a) have kernel ASLR enabled.

b) are passing perf data collected in system-wide mode from superuser
to a normal user.

c) want to hide the start address of the kallsyms_stext shared object
for security reasons.

The remapped perf.data has addresses that are different from the
original perf.data file, but the offsets from the start of the shared
objects are unchanged. Such a remapped perf.data file produces the
same `perf report` output as the original perf.data file.


4. Quipper can discard PERF_RECORD_MMAP events that are not required
by any PERF_RECORD_SAMPLE events (a PERF_RECORD_MMAP can be disarded
if no PERF_RECORD_SAMPLE event occurs within its mapped region). This
can reduce the perf data size by over 50 percent in some cases. A
reduced perf.data file produces the same `perf report` output as the
original perf.data file.


We hope developers can use this perf reader library to:

1. serialize perf data to protocol buffer format and back.

2. write their own symbolizers/analyzers of the perf.data.

3. develop other conversion tools.


Feel free to try it out and let us know of any bugs at: http://crbug.com/.


Future direction

================


1. We would like to push this library alongside perf to be the
"official C++ perf reader" library/protobuf converter. By coupling
this with the official perf distribution we can maintain a consistent
schema, backed by a set of tests to ensure the perf tool, reader and
serializer (to protobuf format) produce compatible data.

2. Another idea is to have perf output in protobuf format natively,
which will enable developers to use a clean, well-documented API to
access perf events and write their own tools on top of it.


We would love to hear the opinions of the developers of LKML on this subject.


Thanks,


asharif@chromium.org

bjanakiraman@chromium.org

sque@chromium.org




[1] Source code available here:
http://git.chromium.org/gitweb/?p=chromiumos/platform/chromiumos-wide-profiling.git;a=summary


[2] https://code.google.com/p/protobuf/


[3] The protocol buffer can be converted back into perf.data and `perf
report` cannot distinguish between the original perf.data and the
re-converted one.


[4] Example human readable data can be dumped with a single function
call (see: https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.text_format)
would look like the following:

events {

 header {

   type: 1

   misc: 1

   size: 80

 }

 mmap_event {

   pid: 4294967295

   tid: 0

   start: 0

   len: 520093696

   pgoff: 0

   filename: "/bin/ls"

   sample_info {

     pid: 0

     tid: 0

     time: 0

   }

 }

}
