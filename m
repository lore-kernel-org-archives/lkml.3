Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbaAGDb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:31:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:24974 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaAGDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:31:25 -0500
Date: Mon, 6 Jan 2014 22:31:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
Message-ID: <20140106223124.0e5fd0b4@gandalf.local.home>
In-Reply-To: <1389063069.3040.90.camel@empanada>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
	<20140106161347.4cc82a4b@gandalf.local.home>
	<1389055673.3040.83.camel@empanada>
	<20140106205034.53c219cc@gandalf.local.home>
	<1389063069.3040.90.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/D=REzzIgGVRj77LCxevw.Gh"
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/D=REzzIgGVRj77LCxevw.Gh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 06 Jan 2014 20:51:09 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> I'll run the next version through my 'testsuite', which unfortunately is
> still manual (one of the many things on my todo list is automate it)..

I have some basic tests, attached is one. Which failed. Here's the
patch that fixes it:

-- Steve

tracing: Fix counter for traceon/off event triggers

The counters for the traceon and traceoff are only suppose to decrement
when the trigger enables or disables tracing. It is not suppose to decrement
every time the event is hit.

Only decrement the counter if the trigger actually did something.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f6dd115..a53e0da 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -742,13 +742,16 @@ traceon_trigger(struct event_trigger_data *data)
 static void
 traceon_count_trigger(struct event_trigger_data *data)
 {
+	if (tracing_is_on())
+		return;
+
 	if (!data->count)
 		return;
 
 	if (data->count != -1)
 		(data->count)--;
 
-	traceon_trigger(data);
+	tracing_on();
 }
 
 static void
@@ -763,13 +766,16 @@ traceoff_trigger(struct event_trigger_data *data)
 static void
 traceoff_count_trigger(struct event_trigger_data *data)
 {
+	if (!tracing_is_on())
+		return;
+
 	if (!data->count)
 		return;
 
 	if (data->count != -1)
 		(data->count)--;
 
-	traceoff_trigger(data);
+	tracing_off();
 }
 
 static int
-- 
1.8.1.4



--MP_/D=REzzIgGVRj77LCxevw.Gh
Content-Type: application/octet-stream; name=ftrace-test-event-traceon-off
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ftrace-test-event-traceon-off

IyEvYmluL2Jhc2gKCmZpbmRfZGVidWdmcygpIHsKICAgIGRlYnVnZnM9YGNhdCAvcHJvYy9tb3Vu
dHMgfCB3aGlsZSByZWFkIG1vdW50IGRpciB0eXBlIG9wdHMgYSBiOyBkbwoJaWYgWyAkbW91bnQg
PT0gImRlYnVnZnMiIF07IHRoZW4KCSAgICBlY2hvICRkaXI7CgkgICAgYnJlYWsKCWZpCiAgICBk
b25lYAogICAgaWYgWyAteiAiJGRlYnVnZnMiIF07IHRoZW4KCWlmICEgbW91bnQgLXQgZGVidWdm
cyBub2RldiAvc3lzL2tlcm5lbC9kZWJ1ZzsgdGhlbgoJICAgIGVjaG8gIkZBSUxFRCB0byBtb3Vu
dCBkZWJ1Z2ZzIgoJICAgIGV4aXQgLTEKCWZpCgllY2hvICIvc3lzL2tlcm5lbC9kZWJ1ZyIKICAg
IGVsc2UKCWVjaG8gJGRlYnVnZnMKICAgIGZpCn0KCmRlYnVnZnM9YGZpbmRfZGVidWdmc2AKVFJB
Q0VESVI9IiRkZWJ1Z2ZzL3RyYWNpbmciCkVWRU5URElSPSRUUkFDRURJUi9ldmVudHMKCmlmIFsg
ISAtZiAkRVZFTlRESVIvc2NoZWQvc2NoZWRfc3dpdGNoL3RyaWdnZXIgXTsgdGhlbgogICAgZWNo
byAidHJpZ2dlcnMgYXJlIG5vdCBzZXQgZm9yIHRoaXMga2VybmVsIgogICAgZXhpdCAwCmZpCgpm
dW5jdGlvbiBjbnRfdHJhY2UoKSB7CgkgICAgZ3JlcCAtdiAnXiMnICRUUkFDRURJUi90cmFjZSB8
IHdjIC1sCn0KCmZ1bmN0aW9uIGNoZWNrX3RyYWNlb24oKSB7CiAgICB2YWw9JDEKICAgIGN1cj1g
Y2F0ICRUUkFDRURJUi90cmFjaW5nX29uYAogICAgaWYgWyAkdmFsIC1uZSAkY3VyIF07IHRoZW4K
CWVjaG8gInRyYWNlb24gZXhwZWN0ZWQgdG8gYmUgJHZhbCBidXQgd2FzICRjdXIiCglleGl0IDEK
ICAgIGZpCn0KCnNldCAteAogICAgICAKZWNobyAnKiogRElTQUJMRSBUUkFDSU5HJwplY2hvIDAg
PiAkVFJBQ0VESVIvdHJhY2luZ19vbiB8fCBleGl0IC0xCmVjaG8gPiAkVFJBQ0VESVIvdHJhY2Ug
fHwgZXhpdCAtMQoKY2hlY2tfdHJhY2VvbiAwCgpjbnQ9YGNudF90cmFjZWAKaWYgWyAkY250IC1u
ZSAwIF07IHRoZW4KICAgZXhpdCAtMQpmaQoKCmVjaG8gJyoqIEVOQUJMRSBGVU5DVElPTiBUUkFD
SU5HJwoKZWNobyBmdW5jdGlvbiA+ICRUUkFDRURJUi9jdXJyZW50X3RyYWNlciB8fCBleGl0IC0x
CgplY2hvICcqKiBFTkFCTEUgVFJBQ0lORycKZWNobyAxID4gJFRSQUNFRElSL3RyYWNpbmdfb24g
fHwgZXhpdCAtMQoKY250PWBjbnRfdHJhY2VgCmlmIFsgJGNudCAtZXEgMCBdOyB0aGVuCiAgIGV4
aXQgLTEKZmkKCmVjaG8gJyoqIFNFVCBFVkVOVCBUUkFDRU9GRicKCmNoZWNrX3RyYWNlb24gMQoK
ZWNobyAidHJhY2VvZmYiID4gJEVWRU5URElSL3NjaGVkL3NjaGVkX3N3aXRjaC90cmlnZ2VyCnNs
ZWVwIDEKY2hlY2tfdHJhY2VvbiAwCmNudD1gY250X3RyYWNlYApzbGVlcCAxCmNudDI9YGNudF90
cmFjZWAKCmlmIFsgJGNudCAtbmUgJGNudDIgXTsgdGhlbgogICBleGl0IC0xOwpmaQoKbGluZTE9
YGNhdCAkVFJBQ0VESVIvdHJhY2UgfCB0YWlsIC0xYApzbGVlcCAxCmxpbmUyPWBjYXQgJFRSQUNF
RElSL3RyYWNlIHwgdGFpbCAtMWAKCmlmIFsgJGxpbmUxICE9ICRsaW5lMiBdOyB0aGVuCiAgIGV4
aXQgLTEKZmkKCmVjaG8gPiAkVFJBQ0VESVIvdHJhY2UgfHwgZXhpdCAtMQoKY2hlY2tfdHJhY2Vv
biAwCgplY2hvICIhdHJhY2VvZmYiID4+ICRFVkVOVERJUi9zY2hlZC9zY2hlZF9zd2l0Y2gvdHJp
Z2dlcgoKY2hlY2tfdHJhY2VvbiAwCgplY2hvICJ0cmFjZW9uIiA+PiAkRVZFTlRESVIvc2NoZWQv
c2NoZWRfc3dpdGNoL3RyaWdnZXIKCnNsZWVwIDEKCmNudD1gY250X3RyYWNlYAppZiBbICRjbnQg
LWVxIDAgXTsgdGhlbgogICBleGl0IC0xCmZpCgpjaGVja190cmFjZW9uIDEKCgplY2hvICIhdHJh
Y2VvbiIgPj4gJEVWRU5URElSL3NjaGVkL3NjaGVkX3N3aXRjaC90cmlnZ2VyCgpjaGVja19zbGVl
cCgpIHsKICAgIHZhbD0kMQogICAgc2xlZXAgMQogICAgY2hlY2tfdHJhY2VvbiAkdmFsCn0KCmVj
aG8gJyoqIFRFU1QgQ09VTlQgdHJhY2VvZmYgKDMpJwoKZWNobyAidHJhY2VvZmY6MyIgPj4gJEVW
RU5URElSL3NjaGVkL3NjaGVkX3N3aXRjaC90cmlnZ2VyCmNoZWNrX3NsZWVwICIwIgplY2hvICcq
KiBURVNUIENPVU5UIHRyYWNlb2ZmICgyKScKZWNobyAxID4gJFRSQUNFRElSL3RyYWNpbmdfb24K
Y2hlY2tfc2xlZXAgIjAiCmVjaG8gJyoqIFRFU1QgQ09VTlQgdHJhY2VvZmYgKDEpJwplY2hvIDEg
PiAkVFJBQ0VESVIvdHJhY2luZ19vbgpjaGVja19zbGVlcCAiMCIKZWNobyAnKiogVEVTVCBDT1VO
VCB0cmFjZW9mZiAoMCknCmVjaG8gMSA+ICRUUkFDRURJUi90cmFjaW5nX29uCmNoZWNrX3NsZWVw
ICIxIgplY2hvICIhdHJhY2VvZmY6MCIgPj4gJEVWRU5URElSL3NjaGVkL3NjaGVkX3N3aXRjaC90
cmlnZ2VyCgplY2hvIG5vcCA+ICRUUkFDRURJUi9jdXJyZW50X3RyYWNlcgoKZWNobyAnKiogU1VD
Q0VTUycKCmV4aXQgMAo=

--MP_/D=REzzIgGVRj77LCxevw.Gh--
