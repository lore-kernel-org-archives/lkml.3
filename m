Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaBRJBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:01:07 -0500
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:45812 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbaBRJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:01:05 -0500
X-Greylist: delayed 1043 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 04:01:04 EST
Message-ID: <53031D2C.2050009@tu-dresden.de>
Date: Tue, 18 Feb 2014 09:43:24 +0100
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Provide additional sample information to Python scripts
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040609060209080203050602"
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040609060209080203050602
Content-Type: multipart/mixed;
 boundary="------------000602000806060002090607"

This is a multi-part message in MIME format.
--------------000602000806060002090607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Good morning,

We have developed a patch for the perf Python scripting interface to
provide additional information about the pid, tid, and cpu of generic
events as well as information about the call-stack and resolved symbol
names. This provides scripts with a greater level of detail. The
mentioned information is already available to the scripting engine and
just has to be handed down. This is done by the attached patch. The
patch is based on Linux-3.13.3.

Please let me know if you have any questions on this.

Thanks
Joseph
--=20
Dipl. Inf. Joseph Schuchart
Computer Scientist

Technische Universit=E4t Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-36494
Fax: +49 351 463-3773
E-Mail: joseph.schuchart@tu-dresden.de

--------------000602000806060002090607
Content-Type: text/x-patch;
 name="perf_pythonscript_add_sample.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="perf_pythonscript_add_sample.patch"

Perf: Provide sample information and call-chain to Python script

Provide additional sample information on generic events to Python=20
scripts, including pid, tid, and cpu for which the event was recorded.
Additionally, provide the call-stack recorded at each event with=20
resolved symbols. At the moment, the pointer to the sample struct
is passed to scripts, which seems to be of little use. The patch
puts this information in dictionaries for easy access by Python
scripts.=20

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

@@ -359,7 +359,7 @@ static void python_process_general_event
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict;
+	PyObject *handler, *retval, *t, *dict, *dict_sample;
 	static char handler_name[64];
 	unsigned n =3D 0;
=20
@@ -375,6 +375,10 @@ static void python_process_general_event
 	if (!dict)
 		Py_FatalError("couldn't create Python dictionary");
=20
+	dict_sample =3D PyDict_New();
+	if (!dict_sample)
+		Py_FatalError("couldn't create Python dictionary");
+
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
=20
 	handler =3D PyDict_GetItemString(main_dict, handler_name);
@@ -384,8 +388,76 @@ static void python_process_general_event
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf=
_evsel__name(evsel)));
 	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(=

 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSiz=
e(
-			(const char *)sample, sizeof(*sample)));
+
+	/* PID/TIDs are limited to 2^29, so we can safely use PyInt */
+	pydict_set_item_string_decref(dict_sample, "pid", PyInt_FromLong(sample=
->pid));
+	pydict_set_item_string_decref(dict_sample, "tid", PyInt_FromLong(sample=
->tid));
+	pydict_set_item_string_decref(dict_sample, "cpu", PyInt_FromLong(sample=
->cpu));
+	pydict_set_item_string_decref(dict_sample, "time", PyLong_FromUnsignedL=
ongLong(sample->time));
+	pydict_set_item_string_decref(dict, "sample", dict_sample);
+
+	/* ip unwinding */
+
+	if (symbol_conf.use_callchain && sample->callchain) {
+		PyObject *pylist;
+
+		if (machine__resolve_callchain(machine, evsel, al->thread,
+						   sample, NULL, NULL, PERF_MAX_STACK_DEPTH) !=3D 0) {
+			pr_err("Failed to resolve callchain. Skipping\n");
+			goto exit;
+		}
+		callchain_cursor_commit(&callchain_cursor);
+
+		pylist =3D PyList_New(0);
+		if (!pylist)
+			Py_FatalError("couldn't create Python list");
+
+		while (1) {
+			PyObject *pyelem;
+			struct callchain_cursor_node *node;
+			node =3D callchain_cursor_current(&callchain_cursor);
+			if (!node)
+				break;
+
+			pyelem =3D PyDict_New();
+			if (!pyelem)
+				Py_FatalError("couldn't create Python dictionary");
+
+
+			pydict_set_item_string_decref(pyelem, "ip", PyInt_FromLong(node->ip))=
;
+
+			if (node->sym) {
+				PyObject *pysym  =3D PyDict_New();
+				if (!pysym)
+					Py_FatalError("couldn't create Python dictionary");
+				pydict_set_item_string_decref(pysym, "start",   PyInt_FromLong(node-=
>sym->start));
+				pydict_set_item_string_decref(pysym, "end",     PyInt_FromLong(node-=
>sym->end));
+				pydict_set_item_string_decref(pysym, "binding", PyInt_FromLong(node-=
>sym->binding));
+				pydict_set_item_string_decref(pysym, "name",    PyString_FromStringA=
ndSize(node->sym->name, node->sym->namelen));
+				pydict_set_item_string_decref(pyelem, "sym", pysym);
+				Py_DECREF(pysym);
+			}
+
+			if (node->map) {
+				struct map *map =3D node->map;
+				const char *dsoname =3D "[unknown]";
+				if (map && map->dso && (map->dso->name || map->dso->long_name)) {
+					if (symbol_conf.show_kernel_path && map->dso->long_name)
+						dsoname =3D map->dso->long_name;
+					else if (map->dso->name)
+						dsoname =3D map->dso->name;
+				}
+				pydict_set_item_string_decref(pyelem, "dso", PyString_FromString(dso=
name));
+			}
+
+			callchain_cursor_advance(&callchain_cursor);
+			PyList_Append(pylist, pyelem);
+			Py_DECREF(pyelem);
+		}
+		PyDict_SetItemString(dict, "callstack", pylist);
+		Py_DECREF(pylist);
+	}
+
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSi=
ze(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
@@ -407,6 +479,7 @@ static void python_process_general_event
 	if (retval =3D=3D NULL)
 		handler_call_die(handler_name);
 exit:
+	Py_DECREF(dict_sample);
 	Py_DECREF(dict);
 	Py_DECREF(t);
 }

--------------000602000806060002090607--

--------------ms040609060209080203050602
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIO6jCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFEzCCA/ugAwIBAgIECpckLTAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDYxOTA5NDkxOFoXDTE5MDYxODAwMDAwMFowgYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQK
Ex9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNV
BAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1kcmVzZGVu
LmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwQ4ek/NE9uzQJ/dQemELBDQV
k/yxH2xj2oDs4TNcNQo8dyAgopWAoCXiD0JgWU/UWpccRds9jhgz3EU7qnGhT5ILXRmsNQRR
CF/pBntyLc9hpWiiz50AR8HKfjg4/DnYLw+MGamJL7I2g8dXJNrKRx1cSxIf+8m3sSS939c2
rajyZCtnybjnnlM9yKe+LD6oSp90AOUOROCVB5b4d5eEwxa25hCDJ7Uaqyfi2htiQkNhvYXx
FL8XqN2a+svPCHRvnex26flyZGWKDnp1SLZvc/mrc6PjQcXZlvJw9NMSQBudsUEsDeB0fqrY
9AnJzLY+Nc17+rpdhO5bUbm6jTN7JwIDAQABo4IBszCCAa8wEgYDVR0TAQH/BAgwBgEB/wIB
ATALBgNVHQ8EBAMCAQYwHQYDVR0OBBYEFMUrU5MXg8n1RkLtQ2rftoCmR/LgMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEXBraUB0dS1kcmVzZGVuLmRl
MIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCBogYIKwYBBQUHAQEEgZUwgZIwRwYI
KwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2Nh
Y2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ds
b2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEA
2KD/xG/6ZPPIt2t1bZGxjOu+qi8ZEsBHFMW3umQpXbClmN8cV7KkYkrfTD/QE8FV0S+Foymq
f1q9zJXwMo5wXAvhqPDUuMcjca7F7oCq5mPJqrA0+Yd1tuQTn6377j8ubm4ukGUxhCTy2Eil
QmogUtC0b/AOZtycNc6Miq+9NO8Juo09ylGHsf420bhCC57v6WuXROAav2XTtvzHEULhrSEv
57kRxthTK5fE19w/OpPtzRG+NDtFAdv2dPrVlDhwh+b7j1DTCmk3CfktV1zNsc86VPdcqlO0
CBSA1L+XXPBel03DgEzErSd8PDcpwZ+KPBYrRLYBxcwbzKkxSPuylDCCBaowggSSoAMCAQIC
Bxa9PhauABkwDQYJKoZIhvcNAQEFBQAwgYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNo
bmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RV
IERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlMB4X
DTEzMTIwMzExMjkxMFoXDTE2MTIwMjExMjkxMFowYDELMAkGA1UEBhMCREUxKDAmBgNVBAoT
H1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEZMBcGA1UE
AxMQSm9zZXBoIFNjaHVjaGFydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALae
/OJvn+KsJJsdsi2U+MVQ7Y7zd1lwUSOdwphbupZv93DMo99hBzxPzy7PydsmKkiNnVD1DUKY
Pj19a26H0HMVwhGAgBK7P6e8p6HxHiaEH+QRdAW7Vwag/tT2h1zgC25OdZVhW8gw2i7AhIde
a7jgutB0U3Uc/M7Q3/o0A3onamQYoxY1O3FCEoZ8TgsZwjp2tdWompg6gmQ2rZcBP/W4+QvC
TWEC5jDaNgB2kCxeHt3vQ7XBnQj0Q48MKy/g5fxJshMkE8uApY0I0o5SkuI7VvrhTTn31Nre
0XwXjScfMYEHvicWStrc5T1oe9iTPegIjx6RwGNl9nFIaYXqj3UCAwEAAaOCAkEwggI9MC8G
A1UdIAQoMCYwEQYPKwYBBAGBrSGCLAEBBAMBMBEGDysGAQQBga0hgiwCAQQDATAJBgNVHRME
AjAAMAsGA1UdDwQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0O
BBYEFNiJZkFqXjpF5fncPtGq351ZNhRJMB8GA1UdIwQYMBaAFMUrU5MXg8n1RkLtQ2rftoCm
R/LgMCkGA1UdEQQiMCCBHmpvc2VwaC5zY2h1Y2hhcnRAdHUtZHJlc2Rlbi5kZTCBiwYDVR0f
BIGDMIGAMD6gPKA6hjhodHRwOi8vY2RwMS5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHVi
L2NybC9nX2NhY3JsLmNybDA+oDygOoY4aHR0cDovL2NkcDIucGNhLmRmbi5kZS90dS1kcmVz
ZGVuLWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwgdkGCCsGAQUFBwEBBIHMMIHJMDMGCCsGAQUF
BzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSAYIKwYBBQUH
MAKGPGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY2FjZXJ0L2df
Y2FjZXJ0LmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2NkcDIucGNhLmRmbi5kZS90dS1kcmVz
ZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQAqHkjX
4MiABsWsK54ITiISGg98SLD72T+2RTFdWkPZbcx4mYFMZ52hFCRFdH/gEm5WGr6ftE/7qdDa
3vnyqpvf1TDcmBvNOvJuozQvu9jcsEA/QSlgk1oA2d0agocM63wau1EUqjSYS0io/0O3vpO5
ghSKsKZ4THhQmYQJDkT1DYrjG8hWDvWobW7iLo4heHNxWA0CWRX/Nx1meJ3huIqHPKobDrl2
gZTdALRMT8NSn6R6sNZMDGsWddGIp/DOJPIDjzSG5ur5dRfMhQh0JGtmZ2gwbnrMIY/p7Y9V
lI6hxA9YaL34nrzDFuxXd546Pk/UTgzIt5DQu1Tm89IbtHLNMYID1DCCA9ACAQEwgZEwgYUx
CzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVzZGVu
MQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG
9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlAgcWvT4WrgAZMAkGBSsOAwIaBQCgggIXMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDIxODA4NDMyNFowIwYJ
KoZIhvcNAQkEMRYEFImgbG6UGo0IZKDl2cZV/eHm9JQsMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgaIGCSsGAQQBgjcQBDGBlDCB
kTCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERy
ZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4G
CSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCBxa9PhauABkwgaQGCyqGSIb3DQEJEAIL
MYGUoIGRMIGFMQswCQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRh
ZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAy
MSAwHgYJKoZIhvcNAQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIHFr0+Fq4AGTANBgkqhkiG9w0B
AQEFAASCAQAazMASUxga8K3yegsxrzDTibI0KrFPgbroGiw7gR9BxP8IpmHZzw8I4150h1Oi
0sN8n05ju6P3WrBX0YWf8186vaCIx5xOVtSqU+3n8rnlRUtucW5Rob7iyasIw0kvfTKF4jr3
9erlwax/2zflk3huk0r+LTdZSXFMZ1s8iyjQbept8J35d5PBciaGQ+iUXCQFsbbn55uKll4E
2f1rWh79ENMFBPn0oKMAz7IjU36CCHLJrPEhUA2aaf7RLMhk3lIGHwmMj8XdhgyhZZorlMJH
nrPIJDAGMODLkWivu+mxALGAGzc1z+Lp+NeWj0J7hdEBkicZ3xyv6mbAflZAgde1AAAAAAAA

--------------ms040609060209080203050602--
